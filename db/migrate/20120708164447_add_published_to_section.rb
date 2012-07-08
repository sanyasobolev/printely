class AddPublishedToSection < ActiveRecord::Migration
  def change
    add_column :sections, :published, :boolean, :default => false
  end
end
