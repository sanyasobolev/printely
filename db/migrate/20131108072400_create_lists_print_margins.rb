# encoding: utf-8
class CreateListsPrintMargins < ActiveRecord::Migration
  def change
    create_table :lists_print_margins do |t|
      t.string :margin
      t.timestamps null: false
    end
  end
end
