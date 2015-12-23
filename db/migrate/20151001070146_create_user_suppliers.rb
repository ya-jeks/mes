class CreateUserSuppliers < ActiveRecord::Migration
  def change
    create_table :user_suppliers do |t|
      t.references :user, index: true, foreign_key: true
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
