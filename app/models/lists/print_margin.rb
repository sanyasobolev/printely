# encoding: utf-8
class Lists::PrintMargin < ActiveRecord::Base
   
   has_many :documents
   has_many :paper_specifications, :through => :documents
   
   belongs_to :order_type

   scope :available_print_margins, -> {lambda { 
      |order_type| joins(:order_type).where("lists_order_types.title = ? OR lists_order_types.title = ?", order_type, 'all').order('lists_print_margins.margin ASC')
    }}
    
    def self.default_print_margin(order_type)
      available_print_margins(order_type.title).first
    end
    
    def self.calc_price(object)
      where(:id => object.print_margin).first.price
    end

    validates :margin, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :margin, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
   
end
