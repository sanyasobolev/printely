class ChangePriceCostColumnInDocuments < ActiveRecord::Migration
  def up
    change_column :documents, :price, :float
    change_column :documents, :cost, :float
  end

  def down
    change_column :documents, :price, :float, :default => 0
    change_column :documents, :cost, :float, :default => 0
  end
end
