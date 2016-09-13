# encoding: utf-8
class CreateSubservices < ActiveRecord::Migration
  def change
   create_table :subservices do |t|
      t.column :title, :string
      t.column :synopsis, :string
      t.column :service_id, :integer
      t.column :permalink, :string
      t.timestamps null: false
    end
  end
end
