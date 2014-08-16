class ChangeListsPaperSizes < ActiveRecord::Migration
  def up
    change_table :lists_paper_sizes do |t|
      t.integer :width
      t.integer :length
    end
  end

  def down
    change_table :lists_paper_sizes do |t|
      t.remove :width
      t.remove :length
    end
  end
end
