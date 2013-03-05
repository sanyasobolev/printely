# encoding: utf-8
class Order < ActiveRecord::Base

  #pagination on page
  cattr_reader :per_page

  belongs_to :user
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true

  #варианты доставки
  DELIVERY_STREET = ['КЭЧ', 'Тарасково', 'Фабричная']

  #размер боксов полей в формах
  DELIVERY_COMMENT_ROWS_SIZE = 2
  DELIVERY_COMMENT_COLS_SIZE = 40

  #статусы
  STATUS = ['Определяется стоимость', 'На обработке', 'Печатается', 'Едет к Вам', 'Выполнен', 'Отклонен' ]

    validate do |order|
      order.errors.add(:delivery_address, "Поле \"#{Order.human_attribute_name(:delivery_address)}\" не должно быть пустым" ) if order.delivery_address.blank?
    end

end
