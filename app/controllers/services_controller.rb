class ServicesController < ApplicationController
  skip_before_filter :login_required, :authorized?,
                     :only => [:index]
  
  def index
    @services = Service.all
    @page_about_services = Page.find_by_permalink('services')
  end

  def new
    @title = 'Создание новой услуги'
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])
    respond_to do |wants|
      if @service.save
        flash[:notice] = 'Услуга создана'
        wants.html { redirect_to admin_services_path }
        wants.xml { render :xml => @service.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @service.errors}
      end
    end
  end

  def edit
    @service = Service.find_by_permalink(params[:id])
    @title = "Редактирование услуги - #{@service.title}"
  end

  def update
    @service = Service.find_by_permalink(params[:id])
    respond_to do |wants|
    if @service.update_attributes(params[:service])
        flash[:notice] = 'Услуга обновлена'
        wants.html { redirect_to admin_services_path }
        wants.xml { render :xml => @service.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @service.errors}
      end
    end
  end

  def destroy
    @service = Service.find_by_permalink(params[:id])
    @service.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_services_path }
      wants.xml { render :nothing => true }
    end
  end

  def admin
    @title = 'Администрирование - Услуги'
    @services = Service.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @services.to_xml }
    end
  end
end
