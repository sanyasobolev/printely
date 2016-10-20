# encoding: utf-8
class AddPermalinkToSections < ActiveRecord::Migration
  def change
     add_column :sections, :permalink, :string
  end
end
