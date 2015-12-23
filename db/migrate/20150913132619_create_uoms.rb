class CreateUoms < ActiveRecord::Migration
  def change
    create_table :uoms do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps null: false
    end

    add_index :uoms, :name, unique: true
  end
end
