class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
    	t.column :first_name, :string
    	t.column :second_name, :string
      t.column :phone, :string
      t.column :role_id, :integer
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
