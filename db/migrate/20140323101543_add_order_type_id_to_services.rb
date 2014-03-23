class AddOrderTypeIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :order_type_id, :integer, :default => 1
    add_column :subservices, :order_type_id, :integer, :default => 1
  end
end
