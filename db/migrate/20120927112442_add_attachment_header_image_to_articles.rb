class AddAttachmentHeaderImageToArticles < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.has_attached_file :header_image
    end
  end

  def self.down
    drop_attached_file :articles, :header_image
  end
end
