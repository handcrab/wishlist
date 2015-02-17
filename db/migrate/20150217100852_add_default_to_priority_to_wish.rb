class AddDefaultToPriorityToWish < ActiveRecord::Migration
  def up
    change_column :wishes, :priority, :integer, default: 0
  end

  def down
    change_column :wishes, :priority, :integer, default: nil
  end
end
