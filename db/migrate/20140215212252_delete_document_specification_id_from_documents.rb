class DeleteDocumentSpecificationIdFromDocuments < ActiveRecord::Migration
  def up
    change_table :documents do |t|
      t.remove :document_specification_id
    end
    drop_table :lists_document_specifications
  end

  def down
    create_table :lists_document_specifications do |t|
      t.integer :paper_specification_id
      t.integer :print_margin_id
      t.boolean :available, :default => true
      t.float :price
      t.timestamps
    end
    add_column :documents, :document_specification_id, :integer
  end
end
