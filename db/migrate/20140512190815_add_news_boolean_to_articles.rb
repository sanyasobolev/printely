class AddNewsBooleanToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :this_news, :boolean, :default => false
  end
end
