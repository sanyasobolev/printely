# encoding: utf-8
class Lists::DocumentSpecification < ActiveRecord::Base
  attr_accessible :id, :available, :paper_specification_id, :print_margin_id, :service_id, :price

  has_many :documents
  
  belongs_to :paper_specification
  belongs_to :print_margin
  belongs_to :service

  validates :paper_specification_id, :uniqueness => { 
    :scope => :print_margin_id,
    :message => "Такая спецификация документа уже есть."
  }

  scope :admin_order, joins(:paper_specification => :paper_size).order('lists_paper_sizes.size').joins(:paper_specification => :paper_type).order('lists_paper_types.paper_type').readonly(false)

end