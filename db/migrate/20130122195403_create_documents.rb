class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :order_id
      t.string :print_format
      t.text :user_comment, :limit => 1000
      t.string :paper_type
      t.timestamps
    end
  end
end
