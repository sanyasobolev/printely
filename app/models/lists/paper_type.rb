# encoding: utf-8
class Lists::PaperType < ActiveRecord::Base
  
  belongs_to :paper_grade
  belongs_to :paper_density
  
  has_many :paper_specifications
  has_many :paper_sizes, :through => :paper_specifications
  has_many :documents, :through => :paper_specifications

  scope :available_paper_types, -> {lambda { 
      |order_type, selected_paper_size| joins(:paper_specifications => [:order_type, :paper_size]).where("lists_paper_sizes.id" => selected_paper_size).where("lists_order_types.title = ? OR lists_order_types.title = ?", order_type, 'all').where('lists_paper_specifications.in_stock' => true).order('lists_paper_types.paper_type ASC')
  }}
  
  def self.default_paper_type(order_type)
    available_paper_types(order_type.title, 
                          Lists::PaperSize.default_paper_size(order_type)
                          ).first
  end

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
