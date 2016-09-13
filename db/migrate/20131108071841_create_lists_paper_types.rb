# encoding: utf-8
class CreateListsPaperTypes < ActiveRecord::Migration
  def change
    create_table :lists_paper_types do |t|
      t.string :paper_type
      t.integer :paper_grade_id
      t.integer :paper_density_id
      t.timestamps null: false
    end


  end
end
