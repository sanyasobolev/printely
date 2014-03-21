# encoding: utf-8
class Lists::PrePrintOperation < ActiveRecord::Base
  
   has_and_belongs_to_many :documents
   belongs_to :order_type
   
   attr_accessible :id, :operation, :price, :order_type_id
   
    validates :operation, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :operation, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
end
