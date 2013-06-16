class AddPriceToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :price, :float
  end
end
