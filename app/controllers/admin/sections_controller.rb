# encoding: utf-8
class Admin::SectionsController < ApplicationController 
  
  def index
    @title = t '.title'
    load_sections
  end

  def new
    @title = t '.title'
    build_section
  end

  def create
    build_section
    set_page
    save_section or render 'new'
  end

  def edit
    @title = t '.title'
    load_section
  end

  def update
    load_section
    build_section
    set_page
    save_section or render 'edit'
  end

  def destroy
    load_section
    @section.destroy
    redirect_to admin_sections_path,
        notice: t('flash.notice.item_deleted') 
  end
  
  
  private
  
  def build_section
    @section ||= section_scope.build
    @section.attributes = section_params
  end  
  
  def load_sections
    @sections ||= section_scope
  end
  
  def load_section
    @section ||= section_scope.find_by permalink: params[:id]
  end  
  
  def save_section
    if @section.save
      redirect_to admin_sections_path,
      notice: t('flash.notice.item_saved')
    end
  end
    
  def section_params
    section_params = params[:section]
    section_params ? 
          (section_params = params[:section].permit(:title, :position, :controller, :action, :permalink, :parent_id )) : 
          (section_params = {:parent_id => params[:parent_id]})
  end
  
  def set_page
    page_params[:id].blank? ? 
           (@section.page = nil) : 
           (@section.page = load_page)
  end 
  
  def load_page
    @page = page_scope.find(params[:section][:page][:id])
  end
  
  def page_params
    page_params = params[:section][:page]
    page_params.permit(:id)   
  end
  
  def section_scope
    Section.all
  end

  def page_scope
    Page.all
  end

end
