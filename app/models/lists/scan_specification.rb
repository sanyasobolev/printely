class Lists::ScanSpecification < ActiveRecord::Base

  belongs_to :paper_size
  belongs_to :order_type

  default_scope {joins(:paper_size).order('lists_paper_sizes.size').readonly(false)}
  scope :pricelist, -> {lambda { |order_type| rewhere where("order_type_id=#{order_type.id} OR order_type_id=1").order('lists_scan_specifications.price') }}
end
