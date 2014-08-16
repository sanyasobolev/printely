# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\_\-\+\s\:]/

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  #include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
   include Sprockets::Helpers::RailsHelper
   include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/order_#{model.order.id}/original" unless model.order.nil?
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  #def default_url
  #  "/images/fallback/" + [version_name, "input.jpg"].compact.join('_')
  #end

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
  
  process :set_content_type
  
#  version :pdf, :if => :pdf? do
#    process :cover
#    process :resize_to_fit => [100, 100]
#    process :convert => :jpg

#    def full_filename (for_file = model.source.file)
#      super.chomp(File.extname(super)) + '.jpg'
#    end
#  end

#  def cover
#    manipulate! do |frame, index|
#      frame if index.zero? # take only the first page of the file
#    end
#  end

  version :thumb, :if => :image? do
    process :resize_to_limit => [135, 135]
    def store_dir
      "uploads/order_#{model.order.id}/thumbs" unless model.order.nil?
    end
  end

  def filename
    if model.paper_specification_id
      paper_specification = Lists::PaperSpecification.find_by_id(model.paper_specification_id)
      margins = model.print_margin.nil? ? '' : ("_#{Lists::PrintMargin.find_by_id(model.print_margin_id).margin}").parameterize
      paper_type = Lists::PaperType.find_by_id(paper_specification.paper_type_id)
      paper_grade = paper_type.paper_grade.grade
      paper_size = Lists::PaperSize.find_by_id(paper_specification.paper_size_id).size
      print_color = model.print_color.nil? ? '' : ("_#{Lists::PrintColor.find_by_id(model.print_color_id).color}").parameterize
      img_proc = model.pre_print_operations.size == 0 ? '_' : '_img_proc_yes_' 
      "#{secure_token}_PP#{img_proc}#{paper_size.parameterize}_#{paper_type.paper_type.parameterize}_#{paper_grade.parameterize}_#{model.quantity}#{margins}#{print_color}.#{file.extension}" if original_filename.present?
    else
      "#{secure_token}_PP_not_set_specification.#{file.extension}" if original_filename.present?
    end
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(4))
    end
    
    def image?(file)
      file.content_type.start_with? 'image'
    end
  
#    def pdf?(file)
#      file.content_type.start_with? 'application/pdf' 
#    end

end
