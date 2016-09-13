# encoding: utf-8
class Admin::Lists::ScanSpecificationsController < ApplicationController

  def index
    @title = "Спецификация услуг по сканированию"
    @lines = ::Lists::ScanSpecification.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @lines.to_xml }
    end
  end

  def edit
    @line = ::Lists::ScanSpecification.find(params[:id])
    @title = "Редактирование записи"
  end

  def update
    @line = ::Lists::ScanSpecification.find(params[:id])
    respond_to do |wants|
      if @line.update_attributes(scan_specification_params)
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
    @line = ::Lists::ScanSpecification.new
  end

  def create
    @line = ::Lists::ScanSpecification.new(scan_specification_params)
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
    @line = ::Lists::ScanSpecification.find(params[:id])
    @line.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_lists_scan_specifications_path }
      wants.xml { render :nothing => true }
    end
  end

  private
  
  def scan_specification_params
    params.require(:line).permit(:paper_size_id, 
                                 :price, 
                                 :order_type_id)
  end

end
