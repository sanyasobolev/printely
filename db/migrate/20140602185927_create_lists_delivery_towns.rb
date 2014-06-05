class CreateListsDeliveryTowns < ActiveRecord::Migration
  def change
    create_table :lists_delivery_towns do |t|
      t.string :title
      t.integer :delivery_zone_id
      t.timestamps
    end
    
    add_column :orders, :delivery_town_id, :integer
  end
end
