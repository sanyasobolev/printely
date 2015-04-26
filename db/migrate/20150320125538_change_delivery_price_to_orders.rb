class ChangeDeliveryPriceToOrders < ActiveRecord::Migration
  def up
    change_column :orders, :delivery_price, :float, :default => 0
    change_column :documents, :price, :float, :default => 0
    change_column :documents, :cost, :float, :default => 0
  end

  def down
    change_column :orders, :delivery_price, :float
    change_column :documents, :price, :float
    change_column :documents, :cost, :float
  end
end
