class CreateSingleVariants < ActiveRecord::Migration
  def up
    execute %(
      create or replace view single_variants as
      select part_products.part_id,
             part_products.product_id
      from part_products
      join (select part_id
            from part_products
            group by part_id
            having count(part_id)=1
           ) standalones on standalones.part_id = part_products.part_id;
    )
  end

  def down
    execute "drop view single_variants;"
  end
end
