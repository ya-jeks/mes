class CreateTaskRelations < ActiveRecord::Migration
  def change
    create_table :task_relations do |t|
      t.references :task, index: true, null: false, foreign_key: true
      t.references :parent, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :task_relations, :tasks, column: :parent_id
  end
end
