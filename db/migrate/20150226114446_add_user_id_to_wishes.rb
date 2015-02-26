class AddUserIdToWishes < ActiveRecord::Migration
  def change
    add_reference :wishes, :user, index: true
    add_foreign_key :wishes, :users
  end
end
