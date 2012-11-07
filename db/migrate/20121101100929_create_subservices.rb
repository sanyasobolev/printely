# encoding: utf-8
class CreateSubservices < ActiveRecord::Migration
  def change
   create_table :subservices do |t|
      t.column :title, :string
      t.column :synopsis, :string
      t.column :service_id, :integer
      t.column :permalink, :string
      t.has_attached_file :subservice_header_icon
      t.timestamps
    end
  end
end
