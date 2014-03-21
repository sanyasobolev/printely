# encoding: utf-8
class Lists::PaperSize < ActiveRecord::Base
   attr_accessible :size, :id, :size_iso_216

  has_many :paper_specifications
  has_many :paper_types, :through => :paper_specifications
  has_many :documents, :through => :paper_specifications
  
    validates :size, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :size, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
  
  default_scope order('size asc')
  
end
