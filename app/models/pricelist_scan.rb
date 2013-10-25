class PricelistScan < ActiveRecord::Base
  attr_accessible :id, :work_name, :work_desc, :price_min, :price_max

end
