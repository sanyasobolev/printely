class Lists::OrderStatus < ActiveRecord::Base
  
  has_many :orders
  
  attr_accessible :title, :key
  
end
