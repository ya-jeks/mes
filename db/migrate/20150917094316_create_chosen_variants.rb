class CreateChosenVariants < ActiveRecord::Migration
  def change
    create_table :chosen_variants do |t|
      t.references :session, index: true
      t.references :product, index: true, foreign_key: true
      t.text :tech_path

      t.timestamps null: false
    end

    add_index :chosen_variants, [:session_id, :tech_path, :product_id], unique: true, name: 'chosen_variants_uniq_idx'
  end
end
