# encoding: utf-8
class CreateListsPaperGrades < ActiveRecord::Migration
  def change
    create_table :lists_paper_grades do |t|
      t.string :grade
      t.timestamps null: false
    end
   
  end
end
