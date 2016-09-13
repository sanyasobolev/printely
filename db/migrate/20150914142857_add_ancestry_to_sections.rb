class AddAncestryToSections < ActiveRecord::Migration
  def change
    add_column :sections, :ancestry, :string
    add_index :sections, :ancestry
    remove_column :sections, :order, :integer
    add_column :sections, :position, :integer
  end
end
