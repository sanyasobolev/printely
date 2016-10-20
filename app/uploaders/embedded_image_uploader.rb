# encoding: utf-8

class EmbeddedImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
   
  storage :file

  def store_dir
    document = Document.find(model.document_id)
    "uploads/order_#{document.order_id}/embedded_img/original" unless model.document.nil?
  end
  
  version :editor_thumb do
    process :resize_to_fill => [50, 50]
    def store_dir
      document = Document.find(model.document_id)
      "uploads/order_#{document.order_id}/embedded_img/editor_thumbs" unless model.document.nil?    
    end
  end

end
