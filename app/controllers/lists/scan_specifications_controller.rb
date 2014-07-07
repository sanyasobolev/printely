# encoding: utf-8
class Lists::ScanSpecificationsController < ApplicationController
layout 'wo_boardlinks', :only => [:admin, :new, :edit]

  def admin
    @title = "Спецификация услуг по сканированию"
    @lines = Lists::ScanSpecification.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @lines.to_xml }
    end
  end

  def edit
    @line = Lists::ScanSpecification.find_by_id(params[:id])
    @title = "Редактирование записи"
  end

  def update
    @line = Lists::ScanSpecification.find_by_id(params[:id])
    respond_to do |wants|
      if @line.update_attributes(params[:line])
          flash[:notice] = 'Запись обновлена'
          wants.html { redirect_to admin_lists_scan_specifications_path }
          wants.xml { render :xml => @line.to_xml }
        else
          wants.html { render :action => "edit" }
          wants.xml {render :xml => @line.errors}
        end
    end
  end

  def new
    @title = 'Создание новой записи'
    @line = Lists::ScanSpecification.new
  end

  def create
    @line = Lists::ScanSpecification.new(params[:line])
    respond_to do |wants|
      if @line.save
        flash[:notice] = 'Запись создана'
        wants.html { redirect_to admin_lists_scan_specifications_path }
        wants.xml { render :xml => @line.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @line.errors}
      end
    end
  end

  def destroy
    @line = Lists::ScanSpecification.find_by_id(params[:id])
    @line.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_lists_scan_specifications_path }
      wants.xml { render :nothing => true }
    end
  end

end
