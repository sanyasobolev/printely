class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.column :name, :string
      t.column :company, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :question, :string
      t.timestamps
    end
  end
end
