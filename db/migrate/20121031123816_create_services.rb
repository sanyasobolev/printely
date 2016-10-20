# encoding: utf-8
class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.column :title, :string
      t.column :synopsis, :string
      t.column :permalink, :string
      t.timestamps null: false
    end

  end
end
