# encoding: utf-8
class Lists::PaperSpecification < ActiveRecord::Base
  
    attr_accessible :paper_type_id, 
                    :paper_size_id, 
                    :in_stock, 
                    :id, 
                    :price, 
                    :order_type_id,
                    :canvas_setting_ids,
                    :product_background_ids
    
    has_many :documents
    has_many :print_margins, :through => :documents

    belongs_to :paper_type
    belongs_to :paper_size
    belongs_to :order_type

    has_and_belongs_to_many :canvas_settings
    has_and_belongs_to_many :product_backgrounds

    validates :paper_type_id, :uniqueness => { 
    :scope => :paper_size_id,
    :message => "Такая спецификация бумаги уже есть."
    }

    validates :price, :presence => {
      :message => "Не должно быть пустым."
    }

  default_scope joins(:paper_size).order('lists_paper_sizes.size').readonly(false)
  scope :pricelist, lambda { |order_type| where("order_type_id=#{order_type.id} OR order_type_id=1").where(:in_stock => true ).joins(:paper_size).order('lists_paper_sizes.size').order('lists_paper_specifications.price') }

  def self.default_paper_specification(order_type)
    where(:paper_type_id => Lists::PaperType.default_paper_type(order_type).id,
          :paper_size_id => Lists::PaperSize.default_paper_size(order_type).id,
          :order_type_id => order_type.id                           
    ).first
  end
  
  def self.find_paper_specification(paper_size, paper_type)
    where(:paper_type_id => paper_type).where(:paper_size_id => paper_size).first
  end
  
  def self.calc_price(object)
    where(:id => object.paper_specification).first.price
  end

    def paper_size_with_iso
      self.paper_size.paper_size_with_iso
    end

    def full_paper_format
      if self.paper_size_with_iso
        "#{self.paper_size_with_iso} , #{self.paper_type.paper_type}"
      else
        "#{self.paper_size.size} , #{self.paper_type.paper_type}"
      end
      
    end
    
    def paper_type_with_grade
      "#{self.paper_type.paper_type} (#{self.paper_type.paper_grade.grade})"
    end 
    
end
