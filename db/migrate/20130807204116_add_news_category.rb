# encoding: utf-8
class AddNewsCategory < ActiveRecord::Migration
  def up
    Category.create(:name => "Архив новостей")
  end

  def down
    
  end
end
