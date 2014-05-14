# encoding: utf-8
class PagesController < ApplicationController
  layout 'services', :only => [:show, :index]
  layout 'welcome', :only => [:welcome]
  skip_before_filter :login_required, :authorized?,
                     :only => [:show, :index, :no_page, :welcome]

  def welcome #for welcome page
    if params[:id] == 'printely'
      @page = Page.find_by_permalink(params[:id])
      @title = @page.title
      #get news list for user
      @news_for_welcome = Article.news_for_welcome
    end
    respond_to do |format|
        format.html
        format.xml { render :xml => @page.to_xml }
    end
  end

  def index #отображение страниц подразделов или других действий подразделов
    if params[:subsection_id] #if click on subsection
      @current_subsection = Subsection.find_by_permalink(params[:subsection_id])
      @title = @current_subsection.title
      @pages = Page.find(:all,
                         :order => 'published_at',
                         :include => :user,
                         :conditions => "subsection_id=#{@current_subsection.id.to_i} AND published=true" )

    end
    @count_of_pages = @pages.count
    @page = @pages.first
    if @count_of_pages > 1
      render :action => 'index', :layout => 'side_pages'
    elsif (@count_of_pages < 1) && @current_subsection.controller != 'no' #if no pages and subsection have controller
      render_another_actions(@current_subsection.controller, @current_subsection.action, nil)     
    elsif @count_of_pages < 1 #if no pages and subsection have not controller
     render :action => :no_page
    end

  end

  def show 
    if params[:section_id] && !params[:subsection_id] #if click on section
      @current_section = Section.find_by_permalink(params[:section_id])
      @page = Page.find_by_section_id(@current_section.id,
                                        :include => :user,
                                        :conditions => "published=true" )
      if @page
        @count_of_pages = 1
        @title = "#{@current_section.title}"
      else
        render :action => :no_page
        @title = "#{@current_section.title} - Страница не готова"
        @count_of_pages = 0
      end
    elsif params[:id] && @page = Page.find_by_permalink(params[:id]) #if click on subsection (what have page) and other pages
      if @current_subsection = Subsection.find_by_id(@page.subsection_id)
        @title = "#{@current_subsection.title}"
        @count_of_pages = @current_subsection.pages.count
      else
        @title = "#{@page.title}"
        @count_of_pages = 1
      end
    elsif params[:id] && @page == nil
      @current_subsection = Subsection.find_by_permalink(params[:subsection_id])
      render_another_actions(@current_subsection.controller, 'show', params[:id])     
      @count_of_pages = 0
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
    @pages = Page.find(:all, :order => 'published_at DESC', :conditions => "id!=1")
  end

  def no_page
    
  end

  def render_another_actions(controller, action, id) #render another actions instead pages
    if controller == 'articles' && action == 'item_news' #for articles-news
      @title = 'Новости'
      @item_news = Article.news_for_user 
      render 'articles/item_news'
    end
    if controller == 'articles' && action == 'show' #for articles-news
      @article = Article.find_by_permalink(id) #news
      @title = @article.title
      render 'articles/show'
    end
  end

end
