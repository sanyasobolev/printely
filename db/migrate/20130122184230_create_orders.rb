# encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.column :user_id, :integer
      t.column :delivery_street, :string
      t.column :delivery_address, :string
      t.column :delivery_comment, :text
      t.column :status, :string
      t.column :cost, :float
      t.column :manager_comment, :text
      t.timestamps
    end

  Page.create(
    :id => '3',
    :title => 'About download',
    :permalink => 'About download',
    :body => 'Эта страница с описанием форматов файлов, которые можно загружать',
    :user_id => '1',
    :published => true)
  end
end
