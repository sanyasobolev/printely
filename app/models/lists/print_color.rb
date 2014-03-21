# encoding: utf-8
class Lists::PrintColor < ActiveRecord::Base
   attr_accessible :id, :color, :price, :order_type_id
   
   has_many :documents
   has_many :paper_specifications, :through => :documents

   belongs_to :order_type

    validates :color, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :color, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
end
