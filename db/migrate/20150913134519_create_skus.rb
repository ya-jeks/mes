class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.references :product, index: true, null: false, foreign_key: true
      t.references :uom, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :skus, [:product_id, :uom_id], unique: true
  end
end
