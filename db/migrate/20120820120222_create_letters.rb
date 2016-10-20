class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.column :name, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :question, :text
      t.timestamps null: false
    end
  end
end
