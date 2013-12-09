# encoding: utf-8
class Lists::OrderStatus < ActiveRecord::Base
  
  has_many :orders
  
  attr_accessible :title, :key

    validates :title, :key, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :title, :uniqueness => {
      :message => 'Такой статус уже есть.'
    }

    validates :key, :uniqueness => {
      :message => 'Такой ключ уже есть.'
    }

end
