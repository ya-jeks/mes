class CreateVariantPrices < ActiveRecord::Migration
  def change
    create_table :variant_prices do |t|
      t.references :product, index: true, foreign_key: true
      t.string :tech_path, null: false
      t.integer :variant_id, null: false
      t.float :price, null: false

      t.timestamps null: false
    end
  end
end
