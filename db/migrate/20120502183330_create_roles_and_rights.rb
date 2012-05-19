class CreateRolesAndRights < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.column "name" , :string
    end

    create_table :rights_roles, :id => false do |t|
      t.column "right_id" , :integer
      t.column "role_id" , :integer
    end

    create_table :rights do |t|
      t.column "name" , :string
      t.column "controller" , :string
      t.column "action" , :string
      t.column "description" , :string
    end

    #Создание базовых ролей
    Role.create(
      :id => '1',
      :name => 'Administrator')

    Role.create(
      :id => '2',
      :name => 'User')

    admin_role = Role.find_by_name('Administrator')

    admin_user = User.create(:id => '1',
                             :first_name => 'Admin',
                             :second_name => 'of system',
                             :email => 'admin@info.net',
                             :password => '123456',
                             :password_confirmation => '123456',
                             :role_id => admin_role.id)

    #установка дефолтной роли для пользователей
    default_role = Role.find_by_name('User')
    change_column :users, :role_id, :integer, :default => default_role

    #создание прав для редактирования своего профиля
    Right.create(
      :id => '1',
      :name => 'access profile edit',
      :controller => 'users',
      :action => 'edit',
      :description => 'access profile edit')

    Right.create(
      :id => '2',
      :name => 'access profile update',
      :controller => 'users',
      :action => 'update',
      :description => 'access profile update')

  end

  def down
    change_column :users, :role_id, :integer, :default => 0
    drop_table :roles
    drop_table :rights
    drop_table :rights_roles
  end
end
