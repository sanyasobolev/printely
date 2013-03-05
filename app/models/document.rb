class Document < ActiveRecord::Base

  belongs_to :order

  attr_accessible :docfile, :print_format, :user_comment, :paper_type, :quantity, :margins
  has_attached_file :docfile,
                    :styles => {
                      :thumb => "100x100>"
                    },
                    :url => "/order_documents/:order_created/:order_number/:style/:name_docfile.:extension",
                    :path => ":rails_root/public/order_documents/:order_created/:order_number/:style/:name_docfile.:extension"

  validates_attachment_size :docfile, :less_than => 100.megabytes

  validate do |document|
    if document.docfile_file_name.blank?
      document.errors.add(:docfile, "Поля под названием \"#{Document.human_attribute_name(:docfile)}\" не должно быть пустыми" )
    else
    unless document.docfile_content_type == 'image/jpg' || document.docfile_content_type == 'image/jpeg' || document.docfile_content_type == 'image/png' || document.docfile_content_type == 'application/zip' || document.docfile_content_type == 'application/x-zip'
      document.errors.add(:docfile, "Вы можете загружать только изображения в формате JPG, PNG и архивы ZIP с изображениями" )
    end
    end
    if document.docfile_file_name != nil && document.docfile_file_size > 100000000
      document.errors.add(:docfile, "Размер каждого из файлов не должен быть больше 100 МБ" )
    end
  end

  #варианты форматов печати
  PRINT_FORMAT = ['10x15', 'А4']
  PAPER_TYPE = ['Глянцевая', 'Матовая']

  #параметры полей
  MARGINS = ['Без полей', 'С полями']
  
  def image?
    upload_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|png|x-png)$}
  end

end
