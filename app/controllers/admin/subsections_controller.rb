# encoding: utf-8
class Admin::SubsectionsController < ApplicationController

  def index
    @title = 'Администрирование - Подразделы'
    @subsections = Subsection.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @subsections.to_xml }
    end
  end

  def new
    @title = 'Создание подраздела'
    @subsection = Subsection.new
  end

  def create
    @subsection = Subsection.create(params[:subsection])
    respond_to do |wants|
      if @subsection.save
        flash[:notice] = 'Подраздел создан'
        wants.html { redirect_to admin_subsections_path }
        wants.xml { render :xml => @subsection.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @subsection.errors}
      end
    end
  end

  def edit
    @subsection = Subsection.find_by_permalink(params[:id])
    @title = "Редактирование подраздела - #{@subsection.title}"
  end

  def update
    @subsection = Subsection.find_by_permalink(params[:id])
    respond_to do |wants|
      if @subsection.update_attributes(params[:subsection])
        wants.html { redirect_to admin_subsections_path }
        wants.xml { render :xml => @subsection.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @subsection.errors}
      end
    end
  end

  def destroy
    @subsection = Subsection.find_by_permalink(params[:id])
    @subsection.destroy
    flash[:notice] = "Подраздел удален."
    respond_to do |wants|
      wants.html { redirect_to admin_subsections_path }
      wants.xml { render :nothing => true }
    end
  end

 
end
