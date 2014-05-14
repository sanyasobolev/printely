# encoding: utf-8
class ArticlesController < ApplicationController
  layout 'articles', :only => [:index]
  layout 'wo_categories', :only => [:show, :admin, :edit, :new, :news]
  skip_before_filter :login_required, :authorized?,
                     :only => [:index, :news, :show]

  def index
    @title = Section.find_by_controller(controller_name).title
    if params[:category_id]
      @category = Category.find_by_permalink(params[:category_id])
      @articles = Article.articles_for_user_with_category(@category)
    else
      @articles = Article.articles_for_user 
    end
    respond_to do |wants| #web-сервис
      wants.html
      wants.xml { render :xml => @articles.to_xml }
    end
  end
  
  def show
    @article = Article.find_by_permalink_and_published(params[:id], true)
    @title = @article.title
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @article.to_xml }
    end
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

  def admin
    @title = "Администрирование - #{Section.find_by_controller(controller_name).title}"
    @articles = Article.find(:all, :order => 'published_at DESC')
  end

end
