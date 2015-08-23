# encoding: utf-8
class ArticleHeaderImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
   include CarrierWave::RMagick

  storage :file
  after :remove, :delete_empty_dirs

  def base_store_dir
    "articles/#{model.id}"
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
 
  process :resize_to_fill => [690, 150]

end
