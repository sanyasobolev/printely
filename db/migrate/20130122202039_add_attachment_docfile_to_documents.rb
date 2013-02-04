class AddAttachmentDocfileToDocuments < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.has_attached_file :docfile
    end
  end

  def self.down
    drop_attached_file :documents, :docfile
  end
end
