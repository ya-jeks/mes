class CreatePartProducts < ActiveRecord::Migration
  def change
    create_table :part_products do |t|
      t.references :part, index: true, null: false, foreign_key: true
      t.references :product, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :part_products, [:part_id, :product_id], unique: true
  end
end
