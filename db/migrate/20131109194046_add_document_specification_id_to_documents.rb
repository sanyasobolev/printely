class AddDocumentSpecificationIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :document_specification_id, :integer
  end
end
