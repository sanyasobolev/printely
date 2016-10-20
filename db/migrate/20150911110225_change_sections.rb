class ChangeSections < ActiveRecord::Migration
  def up
    change_column :sections, :controller, :string, :default => nil
    change_column :sections, :action, :string, :default => nil
    remove_column :sections, :published
  end
  
  def down
    change_column :sections, :controller, :string, :default => 'no'
    change_column :sections, :action, :string, :default => 'no'
    add_column :sections, :published, :boolean
  end  
end
