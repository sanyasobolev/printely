class AddDeliveryPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_price, :float
  end
end
