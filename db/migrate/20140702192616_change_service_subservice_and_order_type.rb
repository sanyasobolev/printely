class ChangeServiceSubserviceAndOrderType < ActiveRecord::Migration
  def up
    change_table :services do |t|
      t.remove :order_type_id
    end
    change_table :subservices do |t|
      t.remove :order_type_id
    end
    change_table :lists_order_types do |t|
      t.integer :service_id
      t.string :description
    end
  end

  def down
    change_table :services do |t|
      t.integer :order_type_id
    end
    change_table :subservices do |t|
      t.integer :order_type_id
    end
    change_table :lists_order_types do |t|
      t.remove :service_id
      t.remove :description
    end
  end
end
