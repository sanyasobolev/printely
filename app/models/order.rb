# encoding: utf-8
class Order < ActiveRecord::Base

  attr_accessible :delivery_town_id, 
                  :delivery_street, 
                  :delivery_address, 
                  :delivery_date, 
                  :delivery_start_time, 
                  :delivery_end_time,  
                  :delivery_price, 
                  :delivery_type, 
                  :documents_attributes, 
                  :order_status_id, 
                  :cost, 
                  :manager_comment, 
                  :created_at, 
                  :order_type_id,
                  :documents_price

  belongs_to :user
  belongs_to :order_status, :class_name => "Lists::OrderStatus"
  belongs_to :order_type, :class_name => "Lists::OrderType"
  belongs_to :delivery_town, :class_name => "Lists::DeliveryTown"
  
  has_many :documents, :dependent => :destroy
  accepts_nested_attributes_for :documents, :allow_destroy => true
  
  DELIVERY_TYPE= ['Курьер']

  #размер боксов полей в формах
  DELIVERY_COMMENT_ROWS_SIZE = 2
  DELIVERY_COMMENT_COLS_SIZE = 40

  DEFAULT_START_TIME = '07:00'
  DEFAULT_END_TIME = '00:00'
  
#  validates :delivery_street, :presence => {
#    :message => "Заполните, пожалуйста, регион доставки."
#  }
  
#  validates :delivery_address, :presence => {
#    :message => "Заполните, пожалуйста, адрес доставки."
#  }
  
#  validates :delivery_date, :presence => {
#    :message => "Заполните, пожалуйста, дату доставки."
#  }
  
  def get_document_specification
     @lines = Hash.new
     Lists::PaperSpecification.all.each do |pspec|
       @documents_quantity = 0
       self.documents.each do |document|
         if pspec == document.paper_specification
           @documents_quantity += document.page_count.to_i*document.quantity.to_i
         end
         unless @documents_quantity == 0
           @lines.merge!(pspec.full_paper_format => @documents_quantity)
         end
       end 
     end
     return @lines
  end
  
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
