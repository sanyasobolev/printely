class AddPageCountToDocuments < ActiveRecord::Migration
  def up
    add_column :documents, :page_count, :integer, :default => 1
    change_column :documents, :quantity, :integer, :default => 1
  end
  
  def down
    remove_column :documents, :page_count
    change_column :documents, :quantity, :integer, :default => 0
  end
end
