# encoding: utf-8
class Order < ActiveRecord::Base

  attr_accessible :delivery_street, :delivery_address, :delivery_date, :delivery_start_time, :delivery_end_time,  :delivery_price, :delivery_type, :documents_attributes, :scan_attributes, :scan, :order_status_id, :cost, :manager_comment, :created_at, :cost_min, :cost_max, :order_type_id

  belongs_to :user
  belongs_to :order_status, :class_name => "Lists::OrderStatus"
  belongs_to :order_type, :class_name => "Lists::OrderType"
  
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true
  
  has_one :scan, :dependent => :destroy
  accepts_nested_attributes_for :scan, :allow_destroy => true
  
  
  #варианты доставки
  DELIVERY_STREET = ['КЭЧ', 'Тарасково', 'Бурцево', 'Петровское']
  DELIVERY_TYPE= ['Курьер']

  #размер боксов полей в формах
  DELIVERY_COMMENT_ROWS_SIZE = 2
  DELIVERY_COMMENT_COLS_SIZE = 40

  DEFAULT_START_TIME = '07:00'
  DEFAULT_END_TIME = '00:00'
  
  validates :delivery_street, :presence => {
    :message => "Заполните, пожалуйста, регион доставки."
  }
  
  validates :delivery_address, :presence => {
    :message => "Заполните, пожалуйста, адрес доставки."
  }
  
  validates :delivery_date, :presence => {
    :message => "Заполните, пожалуйста, дату доставки."
  }
  
  def read_status_key #get status key for current order
    Lists::OrderStatus.where(:id => self.order_status_id).first.key
  end

  def read_status_id #get status id for current order
    Lists::OrderStatus.where(:id => self.order_status_id).first.id
  end

  def set_status(status_key) #set status for current order
    self.order_status_id = Lists::OrderStatus.where(:key => status_key).first.id
  end

end
