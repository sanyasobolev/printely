class AddTerritoryAndDeliverylimittimeToPricelistDeliveries < ActiveRecord::Migration
  def change
    add_column :pricelist_deliveries, :territory, :text
    add_column :pricelist_deliveries, :delivery_limit_time, :string
  end
end
