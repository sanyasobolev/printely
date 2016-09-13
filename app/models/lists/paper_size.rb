# encoding: utf-8
class Lists::PaperSize < ActiveRecord::Base
  before_create :create_size
  before_save :update_size

  has_many :paper_specifications
  has_many :paper_types, :through => :paper_specifications
  has_many :documents, :through => :paper_specifications
  has_many :pricelist_scans
  
  default_scope {order('size asc')} 
  scope :available_paper_sizes, -> {lambda { 
      |order_type| joins(:paper_specifications => :order_type).where("lists_order_types.title = ? OR lists_order_types.title = ?", order_type, 'all').where('lists_paper_specifications.in_stock' => true).uniq
  }}

  def self.default_paper_size(order_type)
    available_paper_sizes(order_type.title).first
  end
  
  
    validates :width, :presence => {
      :message => "Не должно быть пустым."
    }
    
    validates :length, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :width, :uniqueness => {
      :scope => :length,
      :message => 'Такой размер уже есть'
    }
  

  
    def paper_size_with_iso
      if self.size_iso_216.blank?
        "#{self.size}" 
      else
        "#{self.size} | #{self.size_iso_216}"
      end
    end
    
  def create_size
    if ( width.to_s =~ /0\Z/ ) #есть на конце ноль
      width_cm = width/10
    else
      width_cm = width/10.0
    end

    if ( length.to_s =~ /0\Z/ ) #есть на конце ноль
      length_cm = length/10
    else
      length_cm = length/10.0
    end
      
    self[:size] = "#{width_cm}" + "×" + "#{length_cm}"
  end

  def update_size
    if ( width.to_s =~ /0\Z/ ) #есть на конце ноль
      width_cm = width/10
    else
      width_cm = width/10.0
    end

    if ( length.to_s =~ /0\Z/ ) #есть на конце ноль
      length_cm = length/10
    else
      length_cm = length/10.0
    end
    self.size = "#{width_cm}" + "×" + "#{length_cm}"
  end
  
end
