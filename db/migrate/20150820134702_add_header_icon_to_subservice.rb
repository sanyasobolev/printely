class AddHeaderIconToSubservice < ActiveRecord::Migration
  def up
    change_table :subservices do |t|
      t.remove :subservice_header_icon_file_name, :subservice_header_icon_content_type, :subservice_header_icon_file_size, :subservice_header_icon_updated_at
      t.string :header_icon
    end
  end
  
   def down
    change_table :subservices do |t|
      t.string :subservice_header_icon_file_name 
      t.string :subservice_header_icon_content_type
      t.string :subservice_header_icon_file_size
      t.string :subservice_header_icon_updated_at
      t.remove :header_icon
    end
  end
end
