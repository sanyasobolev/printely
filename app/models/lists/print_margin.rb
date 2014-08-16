# encoding: utf-8
class Lists::PrintMargin < ActiveRecord::Base
   attr_accessible :id, :margin, :price, :order_type_id
   
   has_many :documents
   has_many :paper_specifications, :through => :documents
   
   belongs_to :order_type
   
    validates :margin, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :margin, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
   
end
