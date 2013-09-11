class ChangeFormatInLetters < ActiveRecord::Migration
  def up
    change_column :letters, :question, :text
  end

  def down
    change_column :letters, :question, :string
  end
end
