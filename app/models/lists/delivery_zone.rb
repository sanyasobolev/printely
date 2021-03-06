# encoding: utf-8
class Lists::DeliveryZone < ActiveRecord::Base
   
   has_many :delivery_towns, :dependent => :destroy
   
   validates :title, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :title, :uniqueness => {
      :message => 'Такой уже есть.'
    }
   
end
