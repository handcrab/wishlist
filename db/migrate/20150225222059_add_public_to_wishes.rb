class AddPublicToWishes < ActiveRecord::Migration
  def change
    add_column :wishes, :public, :boolean, default: true
  end
end
