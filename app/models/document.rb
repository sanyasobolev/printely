# encoding: utf-8
class Document < ActiveRecord::Base

  belongs_to :order
  belongs_to :document_specification, :class_name => "Lists::DocumentSpecification"
  belongs_to :paper_specification, :class_name => "Lists::PaperSpecification"
  belongs_to :print_margin, :class_name => "Lists::PrintMargin"
  belongs_to :print_color, :class_name => "Lists::PrintColor"
  belongs_to :binding, :class_name => "Lists::Binding"
  has_and_belongs_to_many :pre_print_operations, :class_name => "Lists::PrePrintOperation"

  mount_uploader :docfile, DocumentUploader

  attr_accessible :docfile, :user_comment, :quantity, :price, :cost, :original_filename, :paper_specification_id, :page_count, :print_margin_id, :print_color_id, :binding_id

  def get_paper_type
    if self.paper_specification.nil?
      return false
    else
      paper_type = self.paper_specification.paper_type
      return paper_type
    end
  end
  
  def get_paper_size
    if self.paper_specification.nil?
      return false
    else
      paper_size = self.paper_specification.paper_size
      return paper_size      
    end
  end
  
  def get_paper_size_with_iso
    if self.paper_specification.nil?
      return false
    else
      paper_size = self.paper_specification.paper_size_with_iso
      return paper_size      
    end
  end

  def get_print_margins
    if self.document_specification.nil?
      return false
    else
      dspec = self.document_specification
      print_margins = dspec.print_margin
      return print_margins
    end
  end
  
  def get_paper_specification
    if self.document_specification.nil?
      return false
    else
      pspec = self.document_specification.paper_specification
      return pspec
    end
  end

end
