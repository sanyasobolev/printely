class AddArticleHeaderImageToArticle < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.string :article_header_image
    end
  end
  
   def down
    change_table :articles do |t|
      t.remove :article_header_image
    end
  end
end
