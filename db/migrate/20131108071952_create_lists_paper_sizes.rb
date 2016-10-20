class CreateListsPaperSizes < ActiveRecord::Migration
  def change
    create_table :lists_paper_sizes do |t|
      t.string :size
      t.string :size_iso_216
      t.integer :width
      t.integer :length
      t.timestamps null: false
    end
  end
end
