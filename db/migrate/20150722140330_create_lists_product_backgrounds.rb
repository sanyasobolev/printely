class CreateListsProductBackgrounds < ActiveRecord::Migration
  def change
    create_table :lists_product_backgrounds do |t|
      t.string :title
      t.string :image
      t.timestamps null: false
    end
  
  
    create_table :paper_specifications_product_backgrounds, :id => false do |t|
      t.column "product_background_id" , :integer
      t.column "paper_specification_id" , :integer
    end
  end
end
