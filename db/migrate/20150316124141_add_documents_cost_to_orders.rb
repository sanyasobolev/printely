class AddDocumentsCostToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :documents_price, :float, :default => 0
  end
end
