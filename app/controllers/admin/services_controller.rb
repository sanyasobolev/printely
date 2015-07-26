# encoding: utf-8
class Admin::ServicesController < ApplicationController

  layout 'wo_boardlinks', :only => [:index, :new, :edit]

  def index
    @title = "Администрирование - #{Section.find_by_controller(controller_name).title}"
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

 
end
