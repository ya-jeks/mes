class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :code, null: false
      t.string :address
      t.boolean :sales, null: false, default: false
      t.integer :capacity, default: 0, null: false

      t.timestamps null: false
    end
  end
end
