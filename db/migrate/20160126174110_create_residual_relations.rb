class CreateResidualRelations < ActiveRecord::Migration
  def change
    create_table :residual_relations do |t|
      t.references :task, index: true, null: false, foreign_key: true
      t.references :residual, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :residual_relations, :tasks, column: :residual_id
  end
end
