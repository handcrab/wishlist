class AddDefaultValueToPriceToWish < ActiveRecord::Migration
  def up    
    change_column :wishes, :price, :decimal, precision: 8, scale: 2, default: 0
  end

  def down
    change_column :wishes, :price, :decimal, precision: 8, scale: 2, default: nil
  end
end
