# encoding: utf-8
class EmbeddedImagesController < ApplicationController
  
  before_filter :login_required
  
  skip_before_filter :verify_authenticity_token,
                     :only => [:create]

  before_filter :find_document,
                :only => [:create, :destroy]
  before_filter :find_or_build_embedded_image,
                :only => [:create, :destroy]

  def create
    #set_defaults_params
    @embedded_image.imgfile = params[:file]
    respond_to do |format|
      unless @embedded_image.save
        flash[:error] = 'File could not be uploaded'
      else
        format.js do
          render :plain => render_to_string(:partial => 'embedded_images/embedded_image', :locals => {:embedded_image => @embedded_image})
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      unless @embedded_image.destroy
        flash[:error] = 'Изображение не может быть удалено.'
      end
        format.js { render :template => 'embedded_images/destroy.js.erb', :layout => false }
    end
  end

  private
    def find_document
      @document = Document.find(params[:document_id])
      raise ActiveRecord::RecordNotFound unless @document
    end

    def find_or_build_embedded_image
      @embedded_image = params[:id] ? @document.embedded_images.find(params[:id]) : @document.embedded_images.build(params[:embedded_image])
    end
  
end
