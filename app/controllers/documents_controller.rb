# encoding: utf-8
class DocumentsController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:create, :destroy, :ajaxupdate]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]


  before_filter :find_order,
                :only => [:create, :destroy]
  before_filter :find_or_build_document,
                :only => [:create, :destroy]

  def create
    #set_defaults_params
    @document.quantity = '1'
    @document.margins = Document::MARGINS[0]
    @document.print_format = Document::PRINT_FORMAT[0]
    @document.paper_type = Document::PAPER_TYPE[0]
    @document.user_filename = params[:Filename] #save user file name
    set_price(@document.print_format, @document.paper_type, @document.quantity)
    #---------------------
    @document.docfile = params[:file]
    respond_to do |format|
      unless @document.save
        flash[:error] = 'Photo could not be uploaded'
      end
      format.js do
        render :text => render_to_string(:partial => 'documents/document', :locals => {:document => @document})
      end
    end
  end

  def ajaxupdate
    @document = Document.find_by_id(params[:id])
    if params[:print_format]
      @document.update_attribute(:print_format, params[:print_format])
    elsif params[:paper_type]
      @document.update_attribute(:paper_type, params[:paper_type])
    elsif params[:quantity]
      @document.update_attribute(:quantity, params[:quantity])
    elsif params[:margins]
      @document.update_attribute(:margins, params[:margins])
    end
    set_price(@document.print_format, @document.paper_type, @document.quantity)
    @document.update_attribute(:price, @document.price)
    change_file_name
    respond_to do |format|
        format.js
      end
  end

  def destroy
    respond_to do |format|
      unless @document.destroy
        flash[:error] = 'Документ не может быть удален.'
      end
        format.js
    end
  end

  private
    def find_order
      @order = current_user.orders.find(params[:order_id])
      raise ActiveRecord::RecordNotFound unless @order
    end

    def find_or_build_document
      @document = params[:id] ? @order.documents.find(params[:id]) : @order.documents.build(params[:document])
    end

    def set_price(print_format, paper_type, quantity)
      @document.price = (PricelistFotoprint.where(:print_format => print_format).where(:paper_type => paper_type).first.price)*quantity
    end
    
    def change_file_name
      @document.docfile.recreate_versions!
      @document.save!
    end

end
