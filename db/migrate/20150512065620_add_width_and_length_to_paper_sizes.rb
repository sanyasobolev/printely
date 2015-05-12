class AddWidthAndLengthToPaperSizes < ActiveRecord::Migration
  def change
    add_column :lists_paper_sizes, :width, :integer
    add_column :lists_paper_sizes, :length, :integer
  end
end
