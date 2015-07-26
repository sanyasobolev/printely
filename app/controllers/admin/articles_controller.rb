# encoding: utf-8
class Admin::ArticlesController < ApplicationController
  layout 'wo_categories', :only => [:index, :edit, :new]

  def index
    @title = "Администрирование - #{Section.find_by_controller(controller_name).title}"
    @articles = Article.find(:all, :order => 'published_at DESC')
  end
  
  
  def new
    @title = 'Создание новой статьи'
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    @current_user.articles << @article
    respond_to do |wants|
      if @article.save
        flash[:notice] = 'Статья создана'
        wants.html { redirect_to admin_articles_path }
        wants.xml { render :xml => @article.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @article.errors}
      end
    end
  end  

  def edit
    @article = Article.find_by_permalink(params[:id])
    @title = "Редактирование статьи - #{@article.title}"
  end

  def update
    @article = Article.find_by_permalink(params[:id])
    respond_to do |wants|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Статья обновлена'
        wants.html { redirect_to admin_articles_path }
        wants.xml { render :xml => @article.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @article.errors}
      end
    end
  end

  def destroy
    @article = Article.find_by_permalink(params[:id])
    @article.destroy
    respond_to do |wants|
      flash[:notice] = 'Статья удалена'
      wants.html { redirect_to admin_articles_path }
      wants.xml { render :nothing => true }
    end
  end

end
