# encoding: utf-8
class ArticlesController < ApplicationController
  
  layout 'articles', :only => [:index]
  layout 'wo_categories', :only => [:show, :item_news]

  def index
    @title = Section.find_by(controller: controller_name).title
    if params[:category_id]
      @category = Category.find_by permalink: params[:category_id]
      @articles = Article.articles_for_user_with_category(@category)
    else
      @articles = Article.articles_for_user 
    end
    respond_to do |wants| #web-сервис
      wants.html
      wants.xml { render :xml => @articles.to_xml }
    end
  end
  
  def item_news
    
  end
  
  def show
    @article = Article.show(params[:id])
    @title = @article.title
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @article.to_xml }
    end
  end

end
