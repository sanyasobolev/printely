# encoding: utf-8
class Lists::OrderType < ActiveRecord::Base
   attr_accessible :title, :id, :service_id, :description
   
   has_many :pricelist_scans
   has_many :paper_specifications
   has_many :pre_print_operations
   has_many :print_colors
   has_many :print_margins
   has_many :orders
   
   belongs_to :service
   belongs_to :subservice
   
    validates :title, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :title, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
   
end
