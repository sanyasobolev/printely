# encoding: utf-8
class PagesController < ApplicationController

  skip_before_filter :login_required, :authorized?,
                     :only => [:show, :index, :no_page, :welcome]

  def index #отображение списка страниц в sidebar
    if params[:section_id]
      @current_section = Section.find_by_permalink(params[:section_id])
      @title =  @current_section.title
      @pages_of_section = Page.find(:all,
                                    :order => 'published_at',
                                    :include => :user,
                                    :conditions => "section_id=#{@current_section.id.to_i} AND published=true" )
      @count_of_pages = @pages_of_section.count
      @page = @pages_of_section.first
    end

    if @count_of_pages > 1
      render :action => 'index', :layout => 'side_pages'
    elsif @count_of_pages < 1
      redirect_to no_page_pages_path
    end
  end

  def no_page
  end

  def welcome
    if params[:id] == 'welcome'
      @page = Page.find_by_permalink(params[:id])
      @title = @page.title
    end
    respond_to do |format|
        format.html
        format.xml { render :xml => @page.to_xml }
    end
  end

  def show #отображение выбранной страницы из sidebar или страницы без раздела
    if params[:id]
      @page = Page.find_by_permalink(params[:id])
      if @section = Section.find_by_id(@page.section_id)
         @pages_of_section = Page.find(:all,
                                       :order => 'published_at',
                                       :include => :user,
                                       :conditions => "section_id=#{@section.id.to_i} AND published=true" )
        @title = "#{@section.title} - #{@page.title}"
        @count_of_pages = @pages_of_section.count
      else
        @title = "#{@page.title}"
        @count_of_pages = 0
      end
    end
    if @count_of_pages > 1
      render :action => 'show', :layout => 'side_pages'
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

  def admin
    @title = 'Администрирование - Страницы'
    @main_page = Page.find_by_id(1)
    @pages = Page.paginate :page => params[:page],
                           :order => 'published_at DESC',
                           :include => :user,
                           :conditions => "id!=1"
  end

end
