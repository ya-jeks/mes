class Sku::Components::Fetcher
  attr_reader :sku_id, :session_id

  def initialize(sku_id:, session_id:)
    @sku_id, @session_id = sku_id, session_id
  end

  def product_id
    @product_id ||= sku.product_id
  end

  def sku
    @sku ||= Sku.find(sku_id)
  end

  def call
    (ActiveRecord::Base.connection.execute query).
      entries.
      map(&:symbolize_keys).
      map{|r| OpenStruct.new(r)}
  end

  private
    def query
      ActiveRecord::Base.send(:sanitize_sql_array, [%(
with recursive sku_components as (
select up.id as id,
       null::integer as parent_id,
       up.sku_id,
       coalesce(techs.label, up.name) as name,
       '/'||up.id||':'||coalesce(cup.id, 0) as tech_path,
       up.part_id,
       cup.id as selected_sku_id,
       cup.product_id as selected_product_id,
       up.qty,
       uoms.id as uom_id,
       (case when sv.product_id is null then true else false end)::bool as visible
from sku_parts up
join uoms on uoms.id = up.uom_id
join skus on skus.id = up.sku_id
left join single_variants sv on up.part_id = sv.part_id
left join techs on techs.tech_path = '/'||up.id||':0'
left join chosen_products cv on cv.tech_path = '/'||up.id||':0'
                            and cv.session_id = ?
left join product_presets on product_presets.product_id = skus.product_id
                         and product_presets.main = 't'
left join preset_variants prv on prv.tech_path = '/'||up.id||':0'
                             and prv.preset_id = product_presets.preset_id
left join skus cup on cup.uom_id = up.uom_id
                  and cup.product_id = coalesce(sv.product_id, cv.product_id, prv.product_id)
where skus.id = ?
union all
select up.id,
       uc.id as parent_id,
       up.sku_id,
       coalesce(techs.label, up.name) as name,
       uc.tech_path||'/'||up.id||':'||coalesce(cup.id, 0) as tech_path,
       up.part_id,
       cup.id as selected_sku_id,
       cup.product_id as selected_product_id,
       up.qty,
       uoms.id as uom_id,
       (case when sv.product_id is null then true else false end)::bool as visible
from sku_components uc
join sku_parts up on up.sku_id = uc.selected_sku_id
join uoms on uoms.id = up.uom_id
join skus root_sku on root_sku.id = ?
left join single_variants sv on up.part_id = sv.part_id
left join techs on techs.tech_path = (uc.tech_path||'/'||up.id||':0')
left join chosen_products cv on cv.tech_path = uc.tech_path||'/'||up.id||':0'
                            and cv.session_id = ?
left join product_presets on product_presets.product_id = root_sku.product_id
                         and product_presets.main = 't'
left join preset_variants prv on prv.tech_path = uc.tech_path||'/'||up.id||':0'
                             and prv.preset_id = product_presets.preset_id
left join skus cup on cup.uom_id = up.uom_id
                  and cup.product_id = coalesce(sv.product_id, cv.product_id, prv.product_id)
)
select uc.id,
       uc.name,
       regexp_replace(uc.tech_path, '\\d+$', '0') as tech_path,
       uc.selected_product_id,
       uc.visible,
       vp.price as price
from sku_components uc
left join variant_prices vp on uc.selected_product_id = vp.variant_id and
                         vp.product_id = ? and
                         vp.tech_path = regexp_replace(uc.tech_path, '\\d+$', '0')
order by uc.name;
        ), session_id, sku_id, sku_id, session_id, product_id])
    end
end
