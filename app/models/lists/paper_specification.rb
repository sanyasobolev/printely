# encoding: utf-8
class Lists::PaperSpecification < ActiveRecord::Base
    attr_accessible :paper_type_id, :paper_size_id, :in_stock, :id, :price, :order_type_id
    
    has_many :documents
    has_many :print_margins, :through => :documents

    belongs_to :paper_type
    belongs_to :paper_size
    belongs_to :order_type

    validates :paper_type_id, :uniqueness => { 
    :scope => :paper_size_id,
    :message => "Такая спецификация бумаги уже есть."
    }

    validates :price, :presence => {
      :message => "Не должно быть пустым."
    }

    default_scope joins(:paper_size).order('lists_paper_sizes.size').readonly(false)
    scope :pricelist, joins(:paper_size).order('lists_paper_sizes.size')

    def full_paper_format
      if self.in_stock == true
        in_stock = 'в наличии'
      else
        in_stock = 'нет бумаги'
      end
      "#{self.paper_size.size}, #{self.paper_type.paper_type}, #{in_stock}"
    end
    
    def full_paper_format_wo_stock
      "#{self.paper_size.size}, #{self.paper_type.paper_type}"
    end
    
    def paper_size_with_iso
      if self.paper_size.size_iso_216.blank?
        "#{self.paper_size.size}" 
      else
        "#{self.paper_size.size} | #{self.paper_size.size_iso_216}"
      end
    end

    def paper_type_with_grade
      "#{self.paper_type.paper_type} (#{self.paper_type.paper_grade.grade})"
    end 
    
end
