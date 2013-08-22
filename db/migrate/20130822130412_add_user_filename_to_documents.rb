class AddUserFilenameToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :user_filename, :string
  end
end
