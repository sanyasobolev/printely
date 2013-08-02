# encoding: utf-8
class PricelistDelivery < ActiveRecord::Base
   attr_accessible :delivery_type, :price, :delivery_limit_time, :territory
end
