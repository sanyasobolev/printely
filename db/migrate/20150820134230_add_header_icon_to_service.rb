class AddHeaderIconToService < ActiveRecord::Migration
  def up
    change_table :services do |t|
      t.remove :service_header_icon_file_name, :service_header_icon_content_type, :service_header_icon_file_size, :service_header_icon_updated_at
      t.string :header_icon
    end
  end
  
   def down
    change_table :services do |t|
      t.string :service_header_icon_file_name 
      t.string :service_header_icon_content_type
      t.string :service_header_icon_file_size
      t.string :service_header_icon_updated_at
      t.remove :header_icon
    end
  end
end
