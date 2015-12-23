class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
