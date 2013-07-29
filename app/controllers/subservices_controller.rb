# encoding: utf-8
class SubservicesController < ApplicationController
  layout 'subservices', :only => [:index, :show]
  layout 'wo_boardlinks', :only => [:admin, :new, :edit]
  skip_before_filter :login_required, :authorized?,
                           :only => [:index, :show]

  def index
    if params[:service_id]
      @service = Service.find_by_permalink(params[:service_id])
      @title = @service.title
      @page_about_service = Page.find_by_service_id(@service.id.to_i)
      @pricelist_for_service_model_name = @service.pricelist
      
      #convert string to model and get pricelist lines
      @lines_of_pricelist = @pricelist_for_service_model_name.constantize.all
      
      #get table name
      @pricelist_for_service_table_name = @pricelist_for_service_model_name.constantize.table_name
      
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
    @service = Service.find_by_permalink(params[:service_id])
    @subservice = Subservice.find_by_permalink(params[:id])
    @title = @subservice.title
    @page_about_subservice = Page.find_by_subservice_id(@subservice.id.to_i)
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @subservice.to_xml }
    end
  end

  def new
    @title = 'Создание новой подуслуги'
    @subservice = Subservice.new
  end

  def create
    @subservice = Subservice.new(params[:subservice])
    respond_to do |wants|
      if @subservice.save
        flash[:notice] = 'Подуслуга создана'
        wants.html { redirect_to admin_subservices_path }
        wants.xml { render :xml => @subservice.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @subservice.errors}
      end
    end
  end

  def edit
    @subservice = Subservice.find_by_permalink(params[:id])
    @title = "Редактирование подуслуги - #{@subservice.title}"
  end

  def update
    @subservice = Subservice.find_by_permalink(params[:id])
    respond_to do |wants|
      if @subservice.update_attributes(params[:subservice])
        flash[:notice] = 'Подуслуга обновлена'
        wants.html { redirect_to admin_subservices_path }
        wants.xml { render :xml => @subservice.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @subservice.errors}
      end
    end
  end

  def destroy
    @subservice = Subservice.find_by_permalink(params[:id])
    @subservice.destroy
    respond_to do |wants|
      flash[:notice] = 'Услуга удалена'
      wants.html { redirect_to admin_subservices_path }
      wants.xml { render :nothing => true }
    end
  end

  def admin
    @title = 'Администрирование - Подуслуги'
    @subservices = Subservice.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @services.to_xml }
    end
  end
end
