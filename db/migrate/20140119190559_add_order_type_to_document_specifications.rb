class AddOrderTypeToDocumentSpecifications < ActiveRecord::Migration
  def change
    add_column :lists_document_specifications, :order_type, :string
  end
end
