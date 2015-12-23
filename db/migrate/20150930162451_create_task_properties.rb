class CreateTaskProperties < ActiveRecord::Migration
  def change
    create_table :task_properties do |t|
      t.references :task, index: true
      t.references :product, index: true, foreign_key: true
      t.float :price, null: false
      t.text :tech_path

      t.timestamps null: false
    end
    add_index :task_properties, [:task_id, :tech_path], unique: true
  end
end
