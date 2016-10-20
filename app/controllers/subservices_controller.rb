# encoding: utf-8
class SubservicesController < ApplicationController
  layout 'subservices', :only => [:index, :show]

  def index
    if params[:service_id]
      @service = Service.find_by permalink: params[:service_id]
      @title = @service.title
      @page_about_service = Page.page_of_service(@service)
      
      @pricelist_for_service_model_name = @service.pricelist.to_s #model name
      
      if @pricelist_for_service_model_name =~ /\A(Lists)/ #if get price from lists
        prefics = @pricelist_for_service_model_name.slice!('Lists') #Lists
        @pricelist_for_service_model_name_wo_prefics = @pricelist_for_service_model_name #model name wo lists
        prefics = prefics + '::' #Lists::
        @pricelist_for_service_model_name = prefics + @pricelist_for_service_model_name_wo_prefics #model name with Lists:: prefics
        
        #get subdirectory from table name
        @pricelist_for_service_table_name = @pricelist_for_service_model_name.constantize.table_name
        @subdirectory = ''
        @subdirectory = @subdirectory + @pricelist_for_service_table_name.to_s
        @subdirectory.slice!('lists_') #example result - paper_specifications
        
        #order_types
        @order_types = @service.order_types

      end
      @subservices = Subservice.where("service_id=#{@service.id.to_i}").order("created_at DESC")
    else
      @subservices = Subservice.all
    end
    respond_to do |wants| #web-сервис
      wants.html
      wants.xml { render :xml => @subservices.to_xml }
    end
  end

   def show
    @service = Service.find_by permalink: params[:service_id]
    @subservice = Subservice.find_by permalink: params[:id]
    @title = @subservice.title
    @page_about_subservice = Page.page_of_subservice(@subservice)
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @subservice.to_xml }
    end
  end

end
