class CreatePresets < ActiveRecord::Migration
  def change
    create_table :presets do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
