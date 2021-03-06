# encoding: utf-8
class Admin::CategoriesController < ApplicationController

  def index
    @title = 'Администрирование - Категории'
    @categories = Category.all
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @categories.to_xml }
    end
  end

  def new
    @title = 'Создание новой категории статей'
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |wants|
      if @category.save
        flash[:notice] = 'Категория создана'
        wants.html { redirect_to admin_categories_path }
        wants.xml { render :xml => @category.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @category.errors}
      end
    end
  end

  def edit
    @category = Category.find_by permalink: params[:id]
    @title = "Редактирование категории - #{@category.name}"
  end

  def update
    @category = Category.find_by permalink: params[:id]
    respond_to do |wants|
    if @category.update_attributes(category_params)
        flash[:notice] = 'Категория обновлена'
        wants.html { redirect_to admin_categories_path }
        wants.xml { render :xml => @category.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @category.errors}
      end
    end
  end

  def destroy
    @category = Category.find_by permalink: params[:id]
    @category.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_categories_path }
      wants.xml { render :nothing => true }
    end
  end

  private
  
  def category_params
    params.require(:category).permit(:name)
  end

end
