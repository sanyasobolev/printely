class CreateListsDeliveryZones < ActiveRecord::Migration
  def change
    create_table :lists_delivery_zones do |t|
      t.string :title
      t.float :price, :default => 0
      t.timestamps null: false
    end
  end
end
