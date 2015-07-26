# encoding: utf-8
class Admin::SubservicesController < ApplicationController
  layout 'wo_boardlinks', :only => [:index, :new, :edit]
  
  def index
    @title = 'Администрирование - Подуслуги'
    @subservices = Subservice.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @services.to_xml }
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


end
