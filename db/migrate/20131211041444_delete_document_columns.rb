class DeleteDocumentColumns < ActiveRecord::Migration
  def up
    change_table :documents do |t|
      t.remove :print_format, :paper_type, :margins
    end
  end

  def down
    add_column :documents, :print_format, :string
    add_column :documents, :paper_type, :string
    add_column :documents, :margins, :string
  end
end
