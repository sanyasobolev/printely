class CreatePricelistFotoprints < ActiveRecord::Migration
  def change
    create_table :pricelist_fotoprints do |t|
      t.string :print_format
      t.string :paper_type
      t.column :price, :float
      t.timestamps
    end
  end
end
