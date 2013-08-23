# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\_\-\+\s\:]/

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
   include Sprockets::Helpers::RailsHelper
   include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/order_#{model.order.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  #  version :thumb do
  #    process :scale => [50, 50]
  #  end
  version :thumb do
    process :resize_to_limit => [100, 100]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
#   def extension_white_list
#     %w(jpg jpeg gif png)
#   end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
      #"#{model.object_id}_pp_#{self.model.attributes['print_format'].parameterize}_#{self.model.attributes['paper_type'].parameterize}_#{self.model.attributes['quantity']}_#{self.model.attributes['margins'].parameterize}"
      "#{model.object_id}_PP_#{model.print_format.parameterize}_#{model.paper_type.parameterize}_#{model.quantity}_#{model.margins.parameterize}"
  end

end
