class DeleteDocumentColumns < ActiveRecord::Migration
  def up
    change_table :documents do |t|
      t.remove :print_format, :paper_type, :margins
    end
    drop_table :pricelist_fotoprints
  end

  def down
    create_table :pricelist_fotoprints do |t|
      t.string :print_format
      t.string :paper_type
      t.column :price, :float
      t.timestamps
    end   
    add_column :documents, :print_format, :string
    add_column :documents, :paper_type, :string
    add_column :documents, :margins, :string
  end
end
