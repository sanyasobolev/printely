class EmbeddedImage < ActiveRecord::Base  
  belongs_to :document
  
  mount_uploader :imgfile, EmbeddedImageUploader
  
 
end
