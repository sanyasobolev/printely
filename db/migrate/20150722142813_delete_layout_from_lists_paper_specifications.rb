class DeleteLayoutFromListsPaperSpecifications < ActiveRecord::Migration
  def up
    change_table :lists_paper_specifications do |t|
      t.remove :layout
    end
  end

  def down
    add_column :lists_paper_specifications, :layout, :string
  end
end
