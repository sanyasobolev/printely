# encoding: utf-8
class ProductBackgroundUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  include CarrierWave::MimeTypes

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
   
  storage :file
  after :remove, :delete_empty_dirs
  
  def base_store_dir
    "product_background_images/#{model.id}"
  end
  
  def store_dir
    "#{base_store_dir}/original"
  end
  
  def delete_empty_dirs
    path = ::File.expand_path(store_dir,root)
    Dir.delete(path) #fails, if path not empty dir
    path = ::File.expand_path(base_store_dir,root)
    Dir.delete(path) #fails, if path not empty dir
    rescue SystemCallError
      true #nothing, the dir is not empty
  end

  process :resize_to_limit => [618, 580]

  version :admin_thumb do
    process :resize_to_limit => [200, 200]
    def store_dir
      "#{base_store_dir}/admin_thumbs"
    end
  end

  version :user_thumb do
    process :resize_to_limit => [135, 135]
    def store_dir
      "#{base_store_dir}/user_thumbs"
    end
  end

end
