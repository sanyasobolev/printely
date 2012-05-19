class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
    	t.column :hashed_password, :string
    	t.column :salt, :string
    	t.column :first_name, :string
    	t.column :second_name, :string
    	t.column :email, :string
    	t.column :remember_token_expires_at, :datetime
      t.column :remember_token, :string
      t.column :created_at, :datetime #автоматическая простановка даты создания
      t.column :updated_at, :datetime #автоматическая простановка даты обновления
      t.column :role_id, :integer
    end
  end

  def self.down
    drop_table :users
  end
end
