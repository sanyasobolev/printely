# encoding: utf-8
class Order < ActiveRecord::Base

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

  def calculate_documents_price
    full_documents_cost = 0
    if self.documents.size > 0
      self.documents.each do |document|
        (full_documents_cost += document.cost)
      end
    end  
    self.update_attribute(:documents_price, full_documents_cost)
  end  

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
