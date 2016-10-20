# encoding: utf-8
class Admin::ServicesController < ApplicationController

  layout 'wo_boardlinks', :only => [:index, :new, :edit]

  def index
    @title = "Администрирование - #{Section.find_by(controller: controller_name).title}"
    @services = Service.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @services.to_xml }
    end
  end
  
  def new
    @title = 'Создание новой услуги'
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
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
    @service = Service.find_by permalink: params[:id]
    @title = "Редактирование услуги - #{@service.title}"
  end

  def update
    @service = Service.find_by permalink: params[:id]
    respond_to do |wants|
    if @service.update_attributes(service_params)
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
    @service = Service.find_by permalink: params[:id]
    @service.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_services_path }
      wants.xml { render :nothing => true }
    end
  end

  private
  
  def service_params
    params.require(:service).permit(:title, 
                                    :synopsis, 
                                    :header_icon, 
                                    :service_id, 
                                    :pricelist, 
                                    :order_type_id)
  end
  
end
