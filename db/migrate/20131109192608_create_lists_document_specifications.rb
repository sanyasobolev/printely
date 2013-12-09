class CreateListsDocumentSpecifications < ActiveRecord::Migration
  def change
    create_table :lists_document_specifications do |t|
      t.integer :paper_specification_id
      t.integer :print_margin_id
      t.boolean :available, :default => true
      t.float :price
      t.timestamps
    end
  end
end
