# encoding: utf-8
class Order < ActiveRecord::Base

  attr_accessible :delivery_street, :delivery_address, :delivery_date, :delivery_start_time, :delivery_end_time,  :delivery_price, :delivery_type, :documents_attributes, :scan_attributes, :scan, :status, :cost, :manager_comment, :created_at, :cost_min, :cost_max, :order_type

  belongs_to :user
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true
  
  has_one :scan, :dependent => :destroy
  accepts_nested_attributes_for :scan, :allow_destroy => true
  
  
  #варианты доставки
  DELIVERY_STREET = ['КЭЧ', 'Тарасково']
  DELIVERY_TYPE= ['Курьер']

  #размер боксов полей в формах
  DELIVERY_COMMENT_ROWS_SIZE = 2
  DELIVERY_COMMENT_COLS_SIZE = 40

  #статусы
  #draft - заказ должен бть удален немедленно
  STATUS = ['draft','на обработке', 'печатается', 'едет к Вам', 'выполнен', 'отклонен']
  DEFAULT_START_TIME = '07:00'
  DEFAULT_END_TIME = '00:00'

  
end
