# encoding: utf-8
class Lists::PaperSpecification < ActiveRecord::Base
    attr_accessible :paper_type_id, :paper_size_id, :in_stock, :id
    
    has_many :document_specifications
    has_many :documents, :through => :document_specifications
    has_many :print_margins, :through => :document_specifications

    belongs_to :paper_type
    belongs_to :paper_size

    validates :paper_type_id, :uniqueness => { 
    :scope => :paper_size_id,
    :message => "Такая спецификация бумаги уже есть."
    }

    default_scope joins(:paper_size).order('lists_paper_sizes.size').readonly(false)
    scope :pricelist, joins(:paper_size).order('lists_paper_sizes.size').joins(:document_specifications).where('lists_document_specifications.available = 1').group('lists_document_specifications.paper_specification_id').order('lists_document_specifications.price')

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
    
    def margins_list
      list = "<ul>"
      available_dspecs = Array.new 
      self.document_specifications.each do |dspec|
        available_dspecs << dspec if dspec.available == true
      end
      available_dspecs.each do |dspec|
        list += "<li>" + "#{dspec.print_margin.margin}" + "</li>"
      end
      list += "</ul>"
      return list.html_safe
    end
    

end
