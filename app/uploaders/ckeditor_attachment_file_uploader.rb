# encoding: utf-8
class CkeditorAttachmentFileUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave

  storage :file

  after :remove, :delete_empty_dirs

  def store_dir
    "ckeditor/attachments/#{model.id}"
  end
  
  def delete_empty_dirs
    path = ::File.expand_path(store_dir,root)
    Dir.delete(path) #fails, if path not empty dir
    rescue SystemCallError
      true #nothing, the dir is not empty
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    Ckeditor.attachment_file_types
  end
end
