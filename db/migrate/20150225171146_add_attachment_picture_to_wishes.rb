class AddAttachmentPictureToWishes < ActiveRecord::Migration
  def self.up
    change_table :wishes do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :wishes, :picture
  end
end
