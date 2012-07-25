class PagesController < ApplicationController
  skip_before_filter :login_required, :authorized?,
                     :only => [:show, :index]

def index #отображение списка страниц в sidebar
  if params[:section_id]
    @title =  Section.find_by_id(params[:section_id]).title
    @pages_of_section = Page.find(:all,
                                  :order => 'published_at',
                                  :include => :user,
                                  :conditions => "section_id=#{params[:section_id].to_i} AND published=true" )
   # @page_default = Page.find( :first, :conditions => "section_id=#{params[:section_id].to_i} AND published=true")
   @page_default = @pages_of_section.first
   @count_of_pages = @pages_of_section.count
  end
  respond_to do |wants| #web-сервис
    wants.html
    wants.xml { render :xml => @pages_of_section.to_xml }
  end
end

  def show #отображение выбранной страницы из sidebar
    if params[:id]
      @page = Page.find_by_permalink(params[:id])
      @title = @page.title
      if @section = Section.find_by_id(@page.section_id) #проверка на случай, если пришла главная страница
         @pages_of_section = Page.find(:all,
                                       :order => 'published_at',
                                       :include => :user,
                                       :conditions => "section_id=#{@section.id.to_i} AND published=true" )
      @title = "#{@section.title} - #{@page.title}"
      end
      respond_to do |format|
        format.html
        format.xml { render :xml => @page.to_xml }
      end
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
