# encoding: utf-8
class Document < ActiveRecord::Base

  belongs_to :order
  belongs_to :document_specification, :class_name => "Lists::DocumentSpecification"
 
  mount_uploader :docfile, DocumentUploader

  attr_accessible :docfile, :print_format, :user_comment, :paper_type, :quantity, :margins, :price, :original_filename, :document_specification_id

  def get_paper_specification
    if self.document_specification.nil?
      return false
    else
      pspec = self.document_specification.paper_specification
      return pspec
    end
  end
    
  def get_paper_type
    if self.document_specification.nil?
      return false
    else
      pspec = self.document_specification.paper_specification
      paper_type = pspec.paper_type.paper_type
      return paper_type
    end
  end
  
  def get_paper_size
    if self.document_specification.nil?
      return false
    else
      pspec = self.document_specification.paper_specification
      paper_size = pspec.paper_size.size
      return paper_size      
    end
  end
  
  def get_paper_size_with_iso
    if self.document_specification.nil?
      return false
    else
      pspec = self.document_specification.paper_specification
      paper_size = pspec.paper_size_with_iso
      return paper_size      
    end
  end
  
  def get_print_margins
    if self.document_specification.nil?
      return false
    else
      dspec = self.document_specification
      print_margins = dspec.print_margin.margin
      return print_margins
    end
  end


end
