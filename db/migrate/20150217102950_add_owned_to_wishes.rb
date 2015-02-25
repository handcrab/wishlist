class AddOwnedToWishes < ActiveRecord::Migration
  def change
    add_column :wishes, :owned, :boolean, default: false
  end
end
