class AddPrintOperationsToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :paper_specification_id, :integer
    add_column :documents, :cost, :float
    add_column :documents, :print_margin_id, :integer
    add_column :documents, :print_color_id, :integer
    add_column :documents, :binding_id, :integer

    add_column :lists_paper_specifications, :price, :float
    
    add_column :lists_print_margins, :price, :float, :default => 0
 end
end
