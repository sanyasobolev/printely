class Document < ActiveRecord::Base

  belongs_to :order

  attr_accessible :docfile, :print_format, :user_comment, :paper_type
  has_attached_file :docfile,
                    :styles => {
                      :thumb => "100x100>"
                    },
                    :url => "/order_documents/:order_number/:style/:id.:extension",
                    :path => ":rails_root/public/order_documents/:order_number/:style/:id.:extension"

  validates_attachment_size :docfile, :less_than => 100.megabytes
  validates_attachment_content_type :docfile,
                                    :content_type => ['image/jpg', 'image/jpeg', 'image/png', 'application/zip', 'application/x-zip']

  #варианты форматов печати
  PRINT_FORMAT = ['10х15', 'А4']
  PAPER_TYPE = ['Глянцевая', 'Матовая']
  
  #размер боксов полей в формах
  USER_COMMENT_ROWS_SIZE = 2
  USER_COMMENT_COLS_SIZE = 40

  def image?
    upload_content_type =~ %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|png|x-png)$}
  end

end
