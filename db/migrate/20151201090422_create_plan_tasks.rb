class CreatePlanTasks < ActiveRecord::Migration
  def change
    create_table :plan_tasks do |t|
      t.references :plan, index: true
      t.references :task, index: true

      t.timestamps null: false
    end

    add_index :plan_tasks, :task_id, unique: true, name: :pt_uniq_idx
  end
end
