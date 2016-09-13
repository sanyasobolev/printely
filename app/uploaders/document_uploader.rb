# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base
  before :cache, 
         :save_original_filename #сохранение пользовательского имени файла
  
  def save_original_filename(file)
    model.user_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\_\-\+\s\:]/

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper


#------------------------------------------------------------------------------
  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/order_#{model.order.id}/original" unless model.order.nil?
  end


#-----------------------------------------------------------------------------
#переписываем метод set_content_type, чтобы загрузчик мог определить content_type
#даже если у файла нет расширения(например, когда создаем png из canvas)
  
  process :set_content_type

  def set_content_type
    if file.extension.blank?
      real_content_type = Magick::Image::read(file.path).first.mime_type
      if file.respond_to?(:content_type=)
        file.content_type = real_content_type
      else
        file.instance_variable_set(:@content_type, real_content_type)
      end 
    else
      if file.content_type.blank? || generic_content_type?
        new_content_type = ::MIME::Types.type_for(file.original_filename).first.to_s
        if file.respond_to?(:content_type=)
          file.content_type = new_content_type
        else
          file.instance_variable_set(:@content_type, new_content_type)
        end
      end    
    end
    rescue ::MIME::InvalidContentType => e
      raise CarrierWave::ProcessingError, I18n.translate(:errors.messages.mime_types_processing_error, :e => e)
  end
#-------------------------------------------------------------------------------



  version :thumb, :if => :image? do
    process :resize_to_limit => [135, 135]
    def store_dir
      "uploads/order_#{model.order.id}/thumbs" unless model.order.nil?
    end
  end
  
  version :svg, :if => :svg? do
    def store_dir
      "uploads/order_#{model.order.id}/svg" unless model.order.nil?
    end
    def filename 
      "canvas.#{get_file_extension}"
    end
  end

  def filename
    if model.paper_specification_id
      paper_specification = Lists::PaperSpecification.find_by_id(model.paper_specification_id)
      margins = model.print_margin.nil? ? '' : ("_#{Lists::PrintMargin.find(model.print_margin_id).margin}").parameterize
      paper_type = Lists::PaperType.find(paper_specification.paper_type_id)
      paper_grade = paper_type.paper_grade.grade
      paper_size = Lists::PaperSize.find(paper_specification.paper_size_id).size
      print_color = model.print_color.nil? ? '' : ("_#{Lists::PrintColor.find(model.print_color_id).color}").parameterize
      img_proc = model.pre_print_operations.size == 0 ? '_' : '_img_proc_yes_' 
      "#{secure_token}_PP#{img_proc}#{paper_size.parameterize}_#{paper_type.paper_type.parameterize}_#{paper_grade.parameterize}_#{model.quantity}#{margins}#{print_color}.#{get_file_extension}" if original_filename.present?
    else
      "#{secure_token}_PP_not_set_specification.#{get_file_extension}" if original_filename.present?
    end
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(4))
    end
    
    def image?(file)
      file.content_type.start_with?("image/jpeg", "image/png")
    end
  
    def svg?(file)
      file.content_type.start_with?("image/svg+xml") 
    end

    def get_file_extension
      case 
      when file.content_type.start_with?("image/jpeg")
        return 'jpg'
      when file.content_type.start_with?("image/png")
        return 'png'
      when file.content_type.start_with?("image/svg+xml")
        return 'svg'
      when file.content_type.start_with?("application/pdf")
        return 'pdf'
      when file.content_type.start_with?("application/msword")
        return 'doc'
      when file.content_type.start_with?("application/vnd.openxmlformats-officedocument.wordprocessingml.document")
        return 'docx'
      when file.content_type.start_with?("application/vnd.ms-powerpoint")
        return 'ppt'
      when file.content_type.start_with?("application/vnd.openxmlformats-officedocument.presentationml.presentation")
        return 'pptx'
      end
    end

end

#examples

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
  #def default_url
  #  asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #end