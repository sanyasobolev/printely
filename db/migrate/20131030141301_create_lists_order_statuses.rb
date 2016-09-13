# encoding: utf-8
class CreateListsOrderStatuses < ActiveRecord::Migration
  def change
    create_table :lists_order_statuses do |t|
      t.string :title
      t.integer :key
      t.timestamps null: false
    end
   
  end
end
