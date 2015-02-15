class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.string :title
      t.integer :priority
      t.decimal :price, precision: 8, scale: 2
      t.text :description

      t.timestamps null: false
    end
  end
end
