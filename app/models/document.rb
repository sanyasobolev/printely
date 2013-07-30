# encoding: utf-8
class Document < ActiveRecord::Base

  belongs_to :order

  mount_uploader :docfile, DocumentUploader

  attr_accessible :docfile, :print_format, :user_comment, :paper_type, :quantity, :margins, :price

  #варианты форматов печати
  PRINT_FORMAT = ['10x15', 'А4']
  PAPER_TYPE = ['Глянцевая', 'Сатин', 'Матовая']

  #параметры полей
  MARGINS = ['Без полей', 'С полями']

end
