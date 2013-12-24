# encoding: utf-8
class Document < ActiveRecord::Base

  belongs_to :order
  belongs_to :document_specification, :class_name => "Lists::DocumentSpecification"
 
  mount_uploader :docfile, DocumentUploader

  attr_accessible :docfile, :print_format, :user_comment, :paper_type, :quantity, :margins, :price, :original_filename, :document_specification_id

  def get_paper_specification
    pspec = self.document_specification.paper_specification
    return pspec
  end
    
  def get_paper_type
    pspec = self.document_specification.paper_specification
    paper_type = pspec.paper_type.paper_type
    return paper_type
  end
  
  def get_paper_size
    pspec = self.document_specification.paper_specification
    paper_size = pspec.paper_size.size
    return paper_size
  end


end
