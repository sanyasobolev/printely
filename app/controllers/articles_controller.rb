# encoding: utf-8
class ArticlesController < ApplicationController
  layout 'articles', :only => [:index]
  layout 'wo_categories', :only => [:show]
  skip_before_filter :login_required, :authorized?,
                     :only => [:index, :show]

  def index
    @title = current_section_title
    if params[:category_id]
      @category = Category.find_by_permalink(params[:category_id])
      @articles = Article.where("category_id=#{@category.id.to_i} AND published=true").order('published_at DESC')
    else
      @articles = Article.where("published=true").order('published_at DESC')    
    end
    respond_to do |wants| #web-сервис
      wants.html
      wants.xml { render :xml => @articles.to_xml }
      wants.rss { render :action => 'rss.rxml', :layout => false }
      wants.atom { render :action => 'atom.rxml', :layout => false }
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
    @title = "Администрирование - #{current_section_title}"
    @articles = Article.find(:all, :order => 'published_at DESC')
  end

end
