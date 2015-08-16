# encoding: utf-8
class Lists::PaperGrade < ActiveRecord::Base
   attr_accessible :grade, :id
   
   has_many :paper_types
   has_many :paper_specifications, :through => :paper_types
   
  
   def self.paper_grades_by_paper_types(paper_types)
     paper_grades = Array.new
     paper_types.each do |paper_type|
        paper_grades << paper_type.paper_grade
     end
     paper_grades = paper_grades.uniq
   end
   
    validates :grade, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :grade, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }

end
