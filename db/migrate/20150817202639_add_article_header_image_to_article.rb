class AddArticleHeaderImageToArticle < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.remove :header_image_file_name, :header_image_content_type, :header_image_file_size, :header_image_updated_at
      t.string :article_header_image
    end
  end
  
   def down
    change_table :articles do |t|
      t.string :header_image_file_name 
      t.string :header_image_content_type
      t.string :header_image_file_size
      t.string :header_image_updated_at
      t.remove :article_header_image
    end
  end
end
