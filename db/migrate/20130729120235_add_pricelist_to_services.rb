class AddPricelistToServices < ActiveRecord::Migration
  def change
    add_column :services, :pricelist, :string
  end
end
