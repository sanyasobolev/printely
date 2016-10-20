# encoding: utf-8
class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.column :title, :string
      t.column :order, :integer
      t.column :controller, :string, :default => 'no'
      t.column :action, :string, :default => 'no'
      t.column :published, :boolean, :default => false
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :sections
  end
end
