# encoding: utf-8
class Admin::PagesController < ApplicationController
  before_filter :login_required
  before_action :role_required

  def index
    @title = 'Администрирование - Страницы'
    @main_page = Page.main_page
    @pages = Page.all_pages
  end

  def show
    @page = Page.find_by permalink: params[:id]
    @title = @page.title
    respond_to do |wants|
      wants.html { render 'pages/show' }
      wants.xml { render :xml => @page.to_xml }
    end
  end
  
  def new
    @title = 'Создание новой страницы'
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    @current_user.pages << @page
    respond_to do |wants|
      if @page.save
        flash[:notice] = 'Страница создана'
        wants.html { redirect_to admin_pages_path }
        wants.xml { render :xml => @page.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @page.errors}
      end
    end
  end

  def edit
    @page = Page.find_by permalink: params[:id]
    @title = "Редактирование страницы - #{@page.title}"
    if @page.id == 1
      @main_page = @page
      @title = "Редактирование главной страницы - #{@main_page.title}"
    end
  end

  def update
    @page = Page.find_by permalink: params[:id]
    @page.attributes = page_params
    respond_to do |wants|
      if @page.save
        flash[:notice] = "Страница обновлена"
        wants.html { redirect_to admin_pages_path }
        wants.xml { render :xml => @page.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @page.errors}
      end
    end
  end

  def destroy
    page_for_delete = Page.find_by permalink: params[:id]
    respond_to do |wants|
      if page_for_delete.id == 1
        flash[:error] = "Нельзя удалить главную страницу!"
      else
        page_for_delete.destroy
        flash[:notice] = "Страница удалена!"
      end
      wants.html { redirect_to admin_pages_path }
      wants.xml { render :nothing => true }
    end
  end
  
  private
  
  def page_params
    params.require(:page).permit(:title, 
                                 :permalink, 
                                 :body, 
                                 :user_id, 
                                 :section_id, 
                                 :subsection_id,
                                 :published, 
                                 :service_id, 
                                 :subservice_id)
  end
  
end
