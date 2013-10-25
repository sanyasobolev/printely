class Scan < ActiveRecord::Base
  
  belongs_to :order
  
  attr_accessible :cost_min, :cost_max, :scan_documents_quantity, :base_correction_documents_quantity, :coloring_documents_quantity, :restoration_documents_quantity, :id
end
