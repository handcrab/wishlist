class AddIndexesToWishes < ActiveRecord::Migration
  def change
    add_index :wishes, :public
    add_index :wishes, :owned
  end
end
