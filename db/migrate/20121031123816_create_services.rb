# encoding: utf-8
class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.column :title, :string
      t.column :synopsis, :string
      t.column :permalink, :string
      t.has_attached_file :service_header_icon
      t.timestamps
    end
    #    создание страницы для описания всех услуг
    Page.create(
    :id => '2',
    :title => 'services',
    :permalink => 'services',
    :body => 'Эта страница с описанием всех услуг',
    :user_id => '1')
  end
end
