# encoding: utf-8
class Document < ActiveRecord::Base

  belongs_to :order
  belongs_to :document_specification, :class_name => "Lists::DocumentSpecification"
 
  mount_uploader :docfile, DocumentUploader

  attr_accessible :docfile, :print_format, :user_comment, :paper_type, :quantity, :margins, :price, :original_filename, :document_specification_id




#OLD_version
  #варианты форматов печати
  PRINT_FORMAT = ['10x15', 'А4']
  PAPER_TYPE = ['Глянцевая', 'Сатин', 'Матовая']

  #параметры полей
  MARGINS = ['Без полей', 'С полями']

end
