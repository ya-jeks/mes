class CreateTechs < ActiveRecord::Migration
  def change
    create_table :techs do |t|
      t.text :tech_path
      t.string :label

      t.timestamps null: false
    end
  end
end
