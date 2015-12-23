class CreateRecalcs < ActiveRecord::Migration
  def change
    create_table :recalcs do |t|
      t.references :sku, index: true, foreign_key: true
      t.references :uom, index: true, foreign_key: true
      t.float :qty, null: false

      t.timestamps null: false
    end

    add_index :recalcs, [:sku_id, :uom_id], unique: true
  end
end
