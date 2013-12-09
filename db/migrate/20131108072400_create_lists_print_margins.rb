# encoding: utf-8
class CreateListsPrintMargins < ActiveRecord::Migration
  def change
    create_table :lists_print_margins do |t|
      t.string :margin
      t.timestamps
    end
    Lists::PrintMargin.create(:margin => 'С полями')
    Lists::PrintMargin.create(:margin => 'Без полей')
  end
end
