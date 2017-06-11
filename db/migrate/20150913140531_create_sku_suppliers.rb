class CreateSkuSuppliers < ActiveRecord::Migration
  def change
    create_table :sku_suppliers do |t|
      t.references :sku, index: true, null: false, foreign_key: true
      t.references :supplier, index: true, null: false, foreign_key: true
      t.integer :duration, default: 0, null: false #seconds
      t.float :price, null: false

      t.timestamps null: false
    end

    add_index :sku_suppliers, [:sku_id, :supplier_id], unique: true, name: 'uv_uniq_idx'
  end
end
