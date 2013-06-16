# encoding: utf-8
class DocumentsController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:create, :destroy]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]


  before_filter :find_order
  before_filter :find_or_build_document
  before_filter :price_calc_default,
              :only => [:create]

  def create
    @document.docfile = params[:file]
    @document.price = @price_default
    respond_to do |format|
      unless @document.save
        flash[:error] = 'Photo could not be uploaded'
      end
      format.js do
        render :text => render_to_string(:partial => 'documents/document', :locals => {:document => @document})
      end
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
    
    def price_calc_default
      @price_default = PricelistFotoprint.where(:print_format => Document::PRINT_FORMAT[0]).where(:paper_type => Document::PAPER_TYPE[0]).first.price
    end

    def find_order
      @order = current_user.orders.find(params[:order_id])
      raise ActiveRecord::RecordNotFound unless @order
    end

    def find_or_build_document
      @document = params[:id] ? @order.documents.find(params[:id]) : @order.documents.build(params[:document])
    end

end
