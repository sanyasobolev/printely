class CreateListsPaperSpecifications < ActiveRecord::Migration
  def change
    create_table :lists_paper_specifications do |t|
      t.integer :paper_type_id
      t.integer :paper_size_id
      t.boolean :in_stock
      t.timestamps null: false
    end
  end
end
