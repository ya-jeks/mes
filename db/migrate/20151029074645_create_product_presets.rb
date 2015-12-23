class CreateProductPresets < ActiveRecord::Migration
  def change
    create_table :product_presets do |t|
      t.references :product, index: true, foreign_key: true
      t.references :preset, index: true, foreign_key: true
      t.boolean :main, null: false, default: false

      t.timestamps null: false
    end
  end
end
