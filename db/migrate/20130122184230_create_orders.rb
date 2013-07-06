# encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.column :user_id, :integer
      t.column :delivery_street, :string
      t.column :delivery_address, :string
      t.column :delivery_date, :date
      t.column :delivery_start_time, :time
      t.column :delivery_end_time, :time
      t.column :status, :string
      t.column :cost, :float
      t.column :manager_comment, :text
      t.timestamps
    end
  end
end
