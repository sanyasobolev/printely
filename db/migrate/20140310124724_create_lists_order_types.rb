class CreateListsOrderTypes < ActiveRecord::Migration
  
  def self.up
      create_table :lists_order_types do |t|
        t.string :title
        t.timestamps null: false
      end

      add_column :lists_paper_specifications, :order_type_id, :integer, :default => 1
      add_column :lists_print_colors, :order_type_id, :integer, :default => 1
      add_column :lists_pre_print_operations, :order_type_id, :integer, :default => 1
      add_column :lists_print_margins, :order_type_id, :integer, :default => 1
      add_column :orders, :order_type_id, :integer
      remove_column :orders, :order_type
  end

  def self.down
    drop_table :lists_order_types
    remove_column :lists_paper_specifications, :order_type_id
    remove_column :lists_print_colors, :order_type_id
    remove_column :lists_pre_print_operations, :order_type_id
    remove_column :lists_print_margins, :order_type_id
    remove_column :orders, :order_type_id
    add_column :orders, :order_type, :string
  end
  
end
