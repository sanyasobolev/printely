# encoding: utf-8
class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string
      t.timestamps
    end
    default_category = Category.create(:name => "Тестовая категория")
    change_column :articles, :category_id, :integer, :default => default_category
  end

  def self.down
    change_column :articles, :category_id, :integer, :default => 0
    drop_table :categories
  end
end
