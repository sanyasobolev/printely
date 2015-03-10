class CreateListsCanvasSettings < ActiveRecord::Migration
  def change
    create_table :lists_canvas_settings do |t|
      t.integer :margin_top, :default => 0
      t.integer :margin_left, :default => 0
      t.integer :width, :default => 100
      t.integer :height, :default => 100
      t.timestamps
    end
    
    create_table :canvas_settings_paper_specifications, :id => false do |t|
      t.column "canvas_setting_id" , :integer
      t.column "paper_specification_id" , :integer
    end
  end
end
