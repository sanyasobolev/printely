class CreateListsBindings < ActiveRecord::Migration
  def change
    create_table :lists_bindings do |t|
      t.string :binding
      t.float :price, :default => 0
      t.timestamps
    end
  end
end
