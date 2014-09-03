class CreateListsPaperDensities < ActiveRecord::Migration
  def change
    create_table :lists_paper_densities do |t|
      t.integer :density
      t.timestamps
    end
      end
end
