class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.integer :order_id
      t.integer :scan_documents_quantity, :default => 1
      t.integer :base_correction_documents_quantity, :default => 0
      t.integer :coloring_documents_quantity ,:default => 0
      t.integer :restoration_documents_quantity, :default => 0
      t.float   :cost_min
      t.float   :cost_max
      t.timestamps
    end
  end
end
