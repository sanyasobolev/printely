# encoding: utf-8
class CkeditorPictureUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave

  include CarrierWave::MiniMagick

  storage :file

  after :remove, :delete_empty_dirs

  def store_dir
    "ckeditor/pictures/#{model.id}"
  end
  
  def delete_empty_dirs
    path = ::File.expand_path(store_dir,root)
    Dir.delete(path) #fails, if path not empty dir
    rescue SystemCallError
      true #nothing, the dir is not empty
  end

  process :read_dimensions

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [118, 100]
  end

  version :content do
    process :resize_to_limit => [900, 900]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    Ckeditor.image_file_types
  end
end
