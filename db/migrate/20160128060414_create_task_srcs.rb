class CreateTaskSrcs < ActiveRecord::Migration
  def change
    create_table :task_srcs do |t|
      t.references :task, null: false, foreign_key: true
      t.references :src, null: false

      t.timestamps null: false
    end

    add_foreign_key :task_srcs, :tasks, column: :src_id
    add_index :task_srcs, [:task_id, :src_id], unique: true
  end
end
