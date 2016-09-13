# encoding: utf-8
class PagesController < ApplicationController

  layout 'welcome', :only => [:welcome]

  def welcome #for welcome page
    if params[:id] == 'printely'
      @page = Page.find_by permalink: params[:id]
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
    if (@count_of_pages == 0) && @current_subsection.controller != 'no' #if no pages and subsection have controller
      render_another_actions(@current_subsection.controller, @current_subsection.action, nil)     
    else #if no pages and subsection have not controller
     raise ActiveRecord::RecordNotFound
    end

  end

  def show 
    if params[:section_id] && !params[:subsection_id] #if click on section
      #@current_section = Section.find_by permalink: params[:section_id]
      #@title = @current_section.title
      #@page = @current_section.page.published
      #@count_of_pages = @page ? 1 : 0
    elsif params[:section_id] && params[:subsection_id] #if click on subsection
      @current_subsection = Subsection.find_by permalink: params[:subsection_id]
      @title = @current_subsection.title
      #смотрим, выбрал ли пользователь subsection или выбрал конкретную страницу в subsection
      @page = params[:id] ? Page.published.find_by(permalink: params[:id]) : @current_subsection.pages.published.first
      @count_of_pages = @current_subsection.pages.published.size
    end

    if @count_of_pages == 1
      render :show
    elsif @count_of_pages > 1
      render :show, layout: 'side_pages'
    else #if no pages or section/subsection have not controller
     raise ActiveRecord::RecordNotFound
    end
  end

  def load_another_action(controller, action)
    if controller == 'articles' && action == 'item_news' #for articles-news
      @title = 'Новости'
      @item_news = Article.news_for_user 
      render 'articles/item_news'
    elsif controller == 'articles' && action == 'show' #for articles-news
      @article = Article.find_by permalink: id #news
      @title = @article.title
      render 'articles/show'
    end
  end
  

end
