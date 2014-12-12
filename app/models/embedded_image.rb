class EmbeddedImage < ActiveRecord::Base
  attr_accessible :document_id, :imgfile
  
  belongs_to :document
  
  mount_uploader :imgfile, EmbeddedImageUploader
  
  
  
end
