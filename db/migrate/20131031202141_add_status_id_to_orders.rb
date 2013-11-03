class AddStatusIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_status_id, :integer
    remove_column :orders, :status
  end
end
