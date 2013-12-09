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

    def full_paper_format
      if self.in_stock == true
        in_stock = 'в наличии'
      else
        in_stock = 'нет бумаги'
      end
      "#{self.paper_size.size}, #{self.paper_type.paper_type}, #{in_stock}"
    end
      
    
end
