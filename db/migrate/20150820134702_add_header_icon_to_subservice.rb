class AddHeaderIconToSubservice < ActiveRecord::Migration
  def up
    change_table :subservices do |t|
      t.string :header_icon
    end
  end
  
   def down
    change_table :subservices do |t|
      t.remove :header_icon
    end
  end
end
