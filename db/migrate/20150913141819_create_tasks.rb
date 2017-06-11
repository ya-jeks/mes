class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :sku, index: true, foreign_key: true
      t.references :supplier, index: true, null: false, foreign_key: true
      t.datetime :due_date
      t.integer :duration
      t.string :state, null: false, index: true
      t.float :price, null: false, default: 0
      t.float :qty, null: false

      t.timestamps null: false
    end
  end
end
