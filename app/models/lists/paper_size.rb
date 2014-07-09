# encoding: utf-8
class Lists::PaperSize < ActiveRecord::Base
   attr_accessible :size, :id, :size_iso_216

  has_many :paper_specifications
  has_many :paper_types, :through => :paper_specifications
  has_many :documents, :through => :paper_specifications
  has_many :pricelist_scans
  
    validates :size, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :size, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
  
  default_scope order('size asc')
  
    def paper_size_with_iso
      if self.size_iso_216.blank?
        "#{self.size}" 
      else
        "#{self.size} | #{self.size_iso_216}"
      end
    end
  
end
