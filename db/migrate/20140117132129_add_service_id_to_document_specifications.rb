class AddServiceIdToDocumentSpecifications < ActiveRecord::Migration
  def change
    add_column :lists_document_specifications, :service_id, :integer
  end
end
