class CreateListsPrintColors < ActiveRecord::Migration
  def change
    create_table :lists_print_colors do |t|
      t.string :color
      t.float :price, :default => 0
      t.timestamps
    end
  end
end
