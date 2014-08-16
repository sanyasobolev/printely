# encoding: utf-8
class Lists::PaperGrade < ActiveRecord::Base
   attr_accessible :grade, :id
   
   has_many :paper_types
   has_many :paper_specifications, :through => :paper_types
   
    validates :grade, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :grade, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }

end
