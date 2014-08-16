class CreateListsPaperDensities < ActiveRecord::Migration
  def change
    create_table :lists_paper_densities do |t|
      t.integer :density
      t.timestamps
    end
    
    add_column :lists_paper_types, :paper_density_id, :integer
  end
end
