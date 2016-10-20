# encoding: utf-8
class Document < ActiveRecord::Base

  require 'base64' #for convert image_data to file
  extend ActiveModel::Callbacks

  belongs_to :order
  belongs_to :paper_specification, :class_name => "Lists::PaperSpecification"
  belongs_to :print_margin, :class_name => "Lists::PrintMargin"
  belongs_to :print_color, :class_name => "Lists::PrintColor"
  belongs_to :binding, :class_name => "Lists::Binding"
  has_and_belongs_to_many :pre_print_operations, :class_name => "Lists::PrePrintOperation"
  has_many :embedded_images, :dependent => :destroy

  mount_uploader :docfile, DocumentUploader

  def initialize(order_type, args={})
    args = defaults(order_type).merge(args)
    @paper_specification_id = args[:paper_specification_id]
    @print_margin_id = args[:print_margin_id]
    @print_color_id = args[:print_color_id]
    @binding_id = args[:binding_id]
    @quantity = args[:quantity]
    @page_count = args[:page_count] 
    super(args)
    calculate_cost
  end
  
  def defaults(order_type)
   {
      :paper_specification_id => Lists::PaperSpecification.default_paper_specification(order_type).id,
      :print_margin_id => Lists::PrintMargin.default_print_margin(order_type).id,
      :print_color_id => Lists::PrintColor.default_print_color(order_type).id,
      :binding_id => nil,
      :page_count => 1,
      :quantity => 1,
    }
  end
  
  def calculate_cost
    @price = (Lists::PaperSpecification.calc_price(self) + Lists::PrintMargin.calc_price(self) + Lists::PrintColor.calc_price(self))*self.page_count
    @cost = @price*self.quantity + Lists::PrePrintOperation.calc_price(self)
    self.update_attributes(:price => @price, :cost => @cost)
    self.order.calculate_documents_price
  end
  
  def change_file_name
    self.docfile.recreate_versions!
    self.save!      
  end
  
  def get_paper_type
    return self.paper_specification.paper_type
  end

  def get_paper_type_with_grade
    if self.paper_specification.nil?
      return false
    else
      paper_type = self.paper_specification.paper_type_with_grade
      return paper_type
    end
  end
  
  def get_paper_size
    return self.paper_specification.paper_size      
  end
  
  def get_paper_size_with_iso
    return self.paper_specification.paper_size.paper_size_with_iso     
  end
  
  def get_canvas_setting
    if self.paper_specification.nil?
      return false
    else
      canvas_setting = self.paper_specification.canvas_settings.first
      return canvas_setting      
    end
  end

end
