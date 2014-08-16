class AddLayoutToListsPaperSpecifications < ActiveRecord::Migration
  def change
    add_column :lists_paper_specifications, :layout, :string
  end
end
