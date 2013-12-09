# encoding: utf-8
class Lists::PaperType < ActiveRecord::Base
  attr_accessible :paper_type, :id, :paper_grade_id
  
  belongs_to :paper_grade
  
  has_many :paper_specifications
  has_many :paper_sizes, :through => :paper_specifications
  has_many :document_specifications, :through => :paper_specifications
  
    validates :paper_type, :presence => {
      :message => "Не должно быть пустым."
    }
  
    validates :paper_type, :uniqueness => { 
    :scope => :paper_grade_id,
    :message => "Такое сочетание тип/класс уже есть."
    }
  
end
