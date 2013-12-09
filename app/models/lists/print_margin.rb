# encoding: utf-8
class Lists::PrintMargin < ActiveRecord::Base
   attr_accessible :id, :margin
   
   has_many :document_specifications
   has_many :paper_spesification, :through => :document_specifications
   
    validates :margin, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :margin, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
   
end
