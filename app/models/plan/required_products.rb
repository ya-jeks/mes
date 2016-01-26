class Plan
  class RequiredProducts
    attr_reader :source_ids

    def initialize(source_ids)
      @source_ids = source_ids
    end

    def data
      (ActiveRecord::Base.connection.execute query).
        entries.map do |r|
          OpenStruct.new ids: r['row_ids'].scan(/^\{(.+)\}$/).last.last.split(',').sort,
                         parent_ids: r['parent_row_ids'].scan(/^\{(.+)\}$/).sort.last.last.split(',').sort,
                         tech_sum: r['tech_sum'].scan(/^\{(.+)\}$/).sort.last.try(:last).try(:split, ',').try(:sort),
                         sku_id: r['sku_id'].to_i,
                         uom_id: r['uom_id'].to_i,
                         product_name: r['product_name'].to_s,
                         src_uom_name: r['src_uom_name'].to_s,
                         cnt: r['cnt'].to_f,
                         qty: r['qty'].to_f,
                         result_cnt: r['result_cnt'].to_f,
                         result_qty: r['result_qty'].to_f,
                         free_qty: r['free_qty'],
                         supplier_id: r['supplier_id'].to_i,
                         supplier_code: r['supplier_code'].to_s,
                         supplier_address: r['supplier_address'].to_s,
                         result_sku_id: r['result_sku_id'].to_i,
                         result_uom_id: r['result_uom_id'].to_i,
                         result_uom_name: r['result_uom_name'].to_s,
                         duration: r['duration'].to_f,
                         price: r['price'].to_f,
                         subtotal: r['subtotal'].to_f
        end
    end

    private
      def query
        ActiveRecord::Base.send(:sanitize_sql_array, [%(
drop table if exists tmp_required_products;
create temp table tmp_required_products (
row_id text,
parent_row_id text,
sku_part_id integer,
parent_sku_id integer,
root_task_id integer,
tech_path text,
row_path text,
selected_sku_id integer,
qty float,
task_qty float
);
with recursive sku_components as (
select md5(tasks.id||'-'||'/'||up.id||':'||coalesce(cup.id, 0)) as row_id,
       tasks.id::text as parent_row_id,
       up.id as sku_part_id,
       up.sku_id as parent_sku_id,
       tasks.id as root_task_id,
       '/'||up.id||':'||coalesce(cup.id, 0) as tech_path,
       '/'||tasks.id||':'||coalesce(cup.id, 0) as row_path,
       cup.id as selected_sku_id,
       up.qty as qty,
       tasks.qty as task_qty
from sku_parts up
left join single_variants on up.part_id = single_variants.part_id
join tasks on tasks.id in (?)
          and tasks.sku_id = up.sku_id
left join task_properties tpr on tpr.tech_path = '/'||up.id||':0'
                             and tpr.task_id = tasks.id
left join skus cup on cup.uom_id = up.uom_id
                  and cup.product_id = coalesce(tpr.product_id, single_variants.product_id)
union all
select md5(uc.row_id||'-'||'/'||up.id||':'||coalesce(cup.id, 0)) as row_id,
       uc.row_id as parent_row_id,
       up.id as sku_part_id,
       up.sku_id as parent_sku_id,
       uc.root_task_id,
       uc.tech_path||'/'||up.id||':'||coalesce(cup.id, 0) as tech_path,
       uc.row_path||'/'||md5(uc.row_id||'-'||'/'||up.id||':'||coalesce(cup.id, 0))||':'||coalesce(cup.id, 0) as row_path,
       cup.id as selected_sku_id,
       up.qty as qty,
       uc.task_qty as task_qty
from sku_components uc
join sku_parts up on up.sku_id = uc.selected_sku_id
left join single_variants on up.part_id = single_variants.part_id
left join task_properties tpr on tpr.task_id = uc.root_task_id
                             and tpr.tech_path = uc.tech_path||'/'||up.id||':0'
left join skus cup on cup.uom_id = up.uom_id
                  and cup.product_id = coalesce(tpr.product_id, single_variants.product_id)
)
insert into tmp_required_products (select uc.* from sku_components uc);
with tmp_required_skus as (
select trp.*,
       trp2.tech_path as tech_path2
from tmp_required_products trp
join tmp_required_products trp2 on trp2.row_path ~ concat('^', trp.row_path)
order by trp.row_id, trp.tech_path, trp2.tech_path
), raw_required_skus as (
select trp.row_id,
       trp.parent_row_id,
       trp.tech_path as tech_path,
       array_remove(array_agg(substring(trp.tech_path2, substring(trp.tech_path, '/\\w+:\\w+$')||'(/.+$)')), null) as tech_sum,
       trp.selected_sku_id,
       trp.qty,
       trp.task_qty
from tmp_required_skus trp
group by trp.row_id, trp.parent_row_id, trp.tech_path, trp.selected_sku_id, trp.qty, trp.task_qty
), required_products as (
select array_agg(rp.row_id) as row_ids,
       array_agg(rp.parent_row_id) as parent_row_ids,
       rp.tech_sum,
       array_agg(rp.tech_path) as tech_paths,
       rp.selected_sku_id as sku_id,
       p.name as product_name,
       sum(rp.task_qty) as cnt,
       rp.qty,
       uoms.id as uom_id,
       uoms.name as src_uom_name
from raw_required_skus rp
join skus on skus.id = rp.selected_sku_id
join products p on p.id = skus.product_id
join uoms on uoms.id = skus.uom_id
group by rp.tech_sum, rp.selected_sku_id, p.name, rp.qty, uoms.id, uoms.name
), result_skus as (
select rp.*,
       uv.supplier_id,
       uv.sku_id as result_sku_id,
       uv.price,
       uv.duration,
       r.qty as result_qty,
       case
         when rp.qty > coalesce(r.qty, 1) then rp.cnt*ceil(rp.qty/coalesce(r.qty, 1))
         when rp.qty < coalesce(r.qty, 1) then ceil(rp.cnt/(floor(coalesce(r.qty, 1)/rp.qty)))
         when rp.qty = coalesce(r.qty, 1) then rp.qty*rp.cnt
       end::integer as result_cnt,
       case
         when rp.qty > coalesce(r.qty, 1) then ARRAY[coalesce(r.qty, 1) - rp.qty::numeric%coalesce(r.qty, 1)::numeric, coalesce(r.qty, 1) - rp.qty::numeric%coalesce(r.qty, 1)::numeric]
         when rp.qty < coalesce(r.qty, 1) then ARRAY[coalesce(r.qty, 1)::numeric%rp.qty::numeric, coalesce(r.qty, 1) - rp.qty*(rp.cnt-(floor(coalesce(r.qty, 1)/rp.qty)*( (ceil(rp.cnt/(floor(coalesce(r.qty, 1)/rp.qty)))) -1)))]
         when rp.qty = coalesce(r.qty, 1) then ARRAY[0, 0]
       end as free_qty,
       au.uom_id as result_uom_id
from required_products rp
left join skus su on su.id = rp.sku_id
left join skus au on au.product_id = su.product_id
left join sku_suppliers uv on uv.sku_id = au.id
left join skus vu on vu.id = uv.sku_id
left join recalcs r on r.sku_id = au.id
                   and r.uom_id = rp.uom_id
order by rp.sku_id
), res2 as (
select ru.*,
       ru.price * ru.result_cnt as subtotal,
       uoms.name as result_uom_name
from result_skus ru
join uoms on uoms.id = ru.result_uom_id
), res3 as (
select res2.row_ids as row_ids2,
       res2.*,
       min(res2.subtotal) over (partition by res2.row_ids) as min_subtotal
from res2
), res4 as (
select res3.*
from res3
where res3.row_ids = res3.row_ids2 and res3.subtotal = res3.min_subtotal
)
select res4.*,
       v.code as supplier_code,
       v.address as supplier_address
from res4
join suppliers v on v.id = res4.supplier_id
order by res4.tech_sum, res4.supplier_id, res4.sku_id;
          ), source_ids])
      end
  end
end
