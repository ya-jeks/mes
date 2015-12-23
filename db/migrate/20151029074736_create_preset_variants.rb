class CreatePresetVariants < ActiveRecord::Migration
  def change
    create_table :preset_variants do |t|
      t.references :preset, index: true, foreign_key: true
      t.text :tech_path, null: false
      t.integer :product_id, null: false

      t.timestamps null: false
    end
  end
end
