# encoding: utf-8
class SectionsController < ApplicationController

  def new
    @title = 'Создание раздела'
    @section = Section.new
  end

  def create
    @section = Section.create(params[:section])
    respond_to do |wants|
      if @section.save
        flash[:notice] = 'Раздел создан'
        wants.html { redirect_to admin_sections_path }
        wants.xml { render :xml => @section.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @section.errors}
      end
    end
  end

  def edit
    @section = Section.find_by_permalink(params[:id])
    @title = "Редактирование раздела - #{@section.title}"
  end

  def update
    @section = Section.find_by_permalink(params[:id])
    respond_to do |wants|
      if @section.update_attributes(params[:section])
        wants.html { redirect_to admin_sections_path }
        wants.xml { render :xml => @section.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @section.errors}
      end
    end
  end

  def destroy
    @section = Section.find_by_permalink(params[:id])
    @section.destroy
    flash[:notice] = "Раздел удален!"
    respond_to do |wants|
      wants.html { redirect_to admin_sections_path }
      wants.xml { render :nothing => true }
    end
  end

  def admin
    @title = 'Администрирование - Разделы'
    @sections = Section.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @sections.to_xml }
    end
  end

end
