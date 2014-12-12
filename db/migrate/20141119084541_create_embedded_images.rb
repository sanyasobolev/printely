class CreateEmbeddedImages < ActiveRecord::Migration
  def change
    create_table :embedded_images do |t|
      t.integer :document_id
      t.string :imgfile
      t.column :created_at, :datetime 
      t.column :updated_at, :datetime
      t.timestamps
    end
  end
end
