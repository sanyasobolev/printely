class AddPageCountToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :page_count, :integer, :default => 1
    change_column :documents, :quantity, :integer, :default => 1
  end
end
