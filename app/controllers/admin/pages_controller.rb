# encoding: utf-8
class Admin::PagesController < ApplicationController


  def index
    @title = 'Администрирование - Страницы'
    @main_page = Page.find_by_id(1)
    @pages = Page.find(:all, :order => 'published_at DESC', :conditions => "id!=1")
  end

  def show
    @page = Page.find_by_permalink(params[:id])
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
    @page = Page.new(params[:page])
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
    @page = Page.find_by_permalink(params[:id])
    @title = "Редактирование страницы - #{@page.title}"
    if @page.id == 1
      @main_page = @page
      @title = "Редактирование главной страницы - #{@main_page.title}"
    end
  end

  def update
    @page = Page.find_by_permalink(params[:id])
    @page.attributes = params[:page]
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
    page_for_delete = Page.find_by_permalink(params[:id])
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
  
end
