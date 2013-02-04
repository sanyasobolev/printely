# encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.column :user_id, :integer
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
