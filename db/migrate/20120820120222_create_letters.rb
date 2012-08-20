class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|

      t.timestamps
    end
  end
end
