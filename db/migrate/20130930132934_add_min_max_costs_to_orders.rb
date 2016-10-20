class AddMinMaxCostsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cost_min, :float
    add_column :orders, :cost_max, :float
    add_column :orders, :order_type, :string
  end
end
