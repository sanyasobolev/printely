# encoding: utf-8
class Order < ActiveRecord::Base

  attr_accessible :delivery_street, :delivery_address, :delivery_comment, :delivery_price, :delivery_type, :documents_attributes, :status, :cost, :manager_comment
  
  #pagination on page
  cattr_reader :per_page

  belongs_to :user
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true
  #варианты доставки
  DELIVERY_STREET = ['КЭЧ', 'Тарасково', 'Фабричная']
  DELIVERY_TYPE= ['Курьер']

  #размер боксов полей в формах
  DELIVERY_COMMENT_ROWS_SIZE = 2
  DELIVERY_COMMENT_COLS_SIZE = 40

  #статусы
  #to_remove - заказ должен бть удален немедленно
  STATUS = ['draft','На обработке', 'Печатается', 'Едет к Вам', 'Выполнен', 'Отклонен']

#    validate do |order|
#      order.errors.add(:delivery_address, "Поле \"#{Order.human_attribute_name(:delivery_address)}\" не должно быть пустым" ) if order.delivery_address.blank?
#    end

end
