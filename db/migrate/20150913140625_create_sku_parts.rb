class CreateSkuParts < ActiveRecord::Migration
  def change
    create_table :sku_parts do |t|
      t.references :sku, index: true, null: false, foreign_key: true
      t.references :part, index: true, null: false, foreign_key: true
      t.float :qty, null: false
      t.references :uom, null: false, foreign_key: true
      t.string :name

      t.timestamps null: false
    end

    add_index :sku_parts, [:sku_id, :part_id, :uom_id, :name], unique: true, name: 'up_uniq_idx'
  end
end
