class CreateListsPrePrintOperations < ActiveRecord::Migration
  def change
    create_table :lists_pre_print_operations do |t|
      t.string :operation
      t.float :price, :default => 0
      t.timestamps null: false
    end

    create_table :documents_pre_print_operations, :id => false do |t|
      t.integer :document_id
      t.integer :pre_print_operation_id
    end

  end
end
