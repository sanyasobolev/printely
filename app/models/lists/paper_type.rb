# encoding: utf-8
class Lists::PaperType < ActiveRecord::Base
  attr_accessible :paper_type, :id, :paper_grade_id, :paper_density_id
  
  belongs_to :paper_grade
  belongs_to :paper_density
  
  has_many :paper_specifications
  has_many :paper_sizes, :through => :paper_specifications
  has_many :documents, :through => :paper_specifications
  
    validates :paper_type, :presence => {
      :message => "Не должно быть пустым."
    }
  
    validates :paper_type, :uniqueness => { 
    :scope => [:paper_grade_id, :paper_density_id],
    :message => "Такое сочетание тип/класс/плотность уже есть."
    }
    
  def paper_type_with_grade
    "#{self.paper_type} (#{self.paper_grade.grade})"
  end

  def paper_type_with_density
    if self.paper_density
      "#{self.paper_type} (#{self.paper_density.density})"
    else
      "#{self.paper_type}"
    end
  end
  
  def paper_type_with_grade_and_density
    if self.paper_density
      "#{self.paper_type} (#{self.paper_grade.grade}), #{self.paper_density.density}"
    else
      "#{self.paper_type} (#{self.paper_grade.grade})"
    end
  end
  
end
