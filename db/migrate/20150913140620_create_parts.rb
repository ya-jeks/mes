class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
