# encoding: utf-8
class Lists::PrePrintOperation < ActiveRecord::Base
  
  has_and_belongs_to_many :documents
  belongs_to :order_type
   
  attr_accessible :id, :operation, :price, :order_type_id
   
  def self.calc_price(object)
    full_price = 0
    object.pre_print_operations.each do |pre_print_operation|
      full_price += pre_print_operation.price
    end
    return full_price
  end
   
  def calc_pre_print_operations_price
      pre_print_operations_price = 0
      if self.pre_print_operations.size > 0 
        self.pre_print_operations.each do |pre_print_operation|
          pre_print_operations_price = pre_print_operations_price + self.pre_print_operation.price
        end
      end
      pre_print_operations_price
  end
   
   
   
    validates :operation, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :operation, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
end
