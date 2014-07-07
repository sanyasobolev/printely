class CreateListsScanSpecifications < ActiveRecord::Migration
  def change
    create_table :lists_scan_specifications do |t|
      t.integer :paper_size_id
      t.float :price, :default => 0
      t.integer :order_type_id, :default => 1
      t.timestamps
    end
  end
end
