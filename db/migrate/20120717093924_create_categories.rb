# encoding: utf-8
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string
      t.column :permalink, :string
      t.timestamps null: false
    end
  end

  def self.down
    change_column :articles, :category_id, :integer, :default => 0
    drop_table :categories
  end
end
