class SubservicesController < ApplicationController
  skip_before_filter :login_required, :authorized?,
                           :only => [:index, :show]

  def index
    @title = 'Услуги'
    if params[:service_id]
      @service = Service.find_by_permalink(params[:service_id])
      @page_about_service = Page.find_by_service_id(@service.id.to_i)
      @subservices = Subservice.where("service_id=#{@service.id.to_i}").order("created_at DESC")
    else
      @subservices = Subservice.all
    end
    respond_to do |wants| #web-сервис
      wants.html
      wants.xml { render :xml => @subservices.to_xml }
    end
  end



end
