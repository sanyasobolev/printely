class AddPaperDensityIdToListsPaperTypes < ActiveRecord::Migration
  def change
    add_column :lists_paper_types, :paper_density_id, :integer
  end
end
