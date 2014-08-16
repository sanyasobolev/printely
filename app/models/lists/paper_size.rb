# encoding: utf-8
class Lists::PaperSize < ActiveRecord::Base
  attr_accessible :size, :id, :size_iso_216, :width, :length

  before_create :create_size
  before_save :update_size

  has_many :paper_specifications
  has_many :paper_types, :through => :paper_specifications
  has_many :documents, :through => :paper_specifications
  has_many :pricelist_scans
  
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
  
  default_scope order('size asc')
  
    def paper_size_with_iso
      if self.size_iso_216.blank?
        "#{self.size}" 
      else
        "#{self.size} | #{self.size_iso_216}"
      end
    end
    
  def create_size
    @attributes['size'] = "#{width/10.0}" + "×" + "#{length/10.0}"
  end

  def update_size
    self.size = "#{width/10.0}" + "×" + "#{length/10.0}"
  end
  
end
