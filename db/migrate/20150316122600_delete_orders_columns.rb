class DeleteOrdersColumns < ActiveRecord::Migration
  def up
    change_table :orders do |t|
      t.remove :cost_min, :cost_max
    end
  end

  def down
    add_column :orders, :cost_min, :float
    add_column :orders, :cost_max, :float
  end
end
