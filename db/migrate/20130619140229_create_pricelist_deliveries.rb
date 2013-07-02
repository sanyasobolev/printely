class CreatePricelistDeliveries < ActiveRecord::Migration
  def change
    create_table :pricelist_deliveries do |t|
      t.string :delivery_type
      t.column :price, :float
      t.timestamps
    end
  end
end
