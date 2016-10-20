# encoding: utf-8
class Lists::PaperDensity < ActiveRecord::Base

  has_many :paper_types
  has_many :paper_specifications, :through => :paper_types
  
    validates :density, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :density, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
  
  default_scope {order('density asc')}
end
