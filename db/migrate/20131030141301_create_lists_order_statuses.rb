# encoding: utf-8
class CreateListsOrderStatuses < ActiveRecord::Migration
  def change
    create_table :lists_order_statuses do |t|
      t.string :title
      t.integer :key
      t.timestamps
    end
    
    Lists::OrderStatus.create(:title => 'draft', :key => 10)
    Lists::OrderStatus.create(:title => 'на обработке', :key => 20)
    Lists::OrderStatus.create(:title => 'печатается', :key => 30)
    Lists::OrderStatus.create(:title => 'едет к Вам', :key => 40)
    Lists::OrderStatus.create(:title => 'выполнен', :key => 50)
    Lists::OrderStatus.create(:title => 'отклонен', :key => 51)
  end
end
