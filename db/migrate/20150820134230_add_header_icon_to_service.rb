class AddHeaderIconToService < ActiveRecord::Migration
  def up
    change_table :services do |t|
      t.string :header_icon
    end
  end
  
   def down
    change_table :services do |t|
      t.remove :header_icon
    end
  end
end
