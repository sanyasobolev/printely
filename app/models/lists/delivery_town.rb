# encoding: utf-8
class Lists::DeliveryTown < ActiveRecord::Base
   attr_accessible :title, :delivery_zone_id

   belongs_to :delivery_zone
   has_many :orders
   
   validates :title, :delivery_zone_id, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :title, :uniqueness => {
      :message => 'Такой уже есть.'
    }
    
    default_scope order('title asc')

end
