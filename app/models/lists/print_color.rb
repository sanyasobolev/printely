# encoding: utf-8
class Lists::PrintColor < ActiveRecord::Base
   attr_accessible :id, :color, :price, :order_type_id
   
   has_many :documents
   has_many :paper_specifications, :through => :documents

   belongs_to :order_type

   scope :available_print_colors, lambda { 
      |order_type| joins(:order_type).where("lists_order_types.title = ? OR lists_order_types.title = ?", order_type, 'all').order('lists_print_colors.color DESC')
    }
    
  def self.default_print_color(order_type)
    available_print_colors(order_type.title).first
  end

  def self.calc_price(object)
    where(:id => object.print_color).first.price
  end

    validates :color, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :color, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
end
