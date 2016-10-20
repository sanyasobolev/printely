# encoding: utf-8
class Admin::Lists::ProductBackgroundsController < ApplicationController

  def index
    @title = 'Изображения продуктов для редактора'
    @productbgs = ::Lists::ProductBackground.all
  end
  
  def new
    @title = 'Загрузка'
    @productbg = ::Lists::ProductBackground.new
  end

  def create
    @productbg = ::Lists::ProductBackground.new(product_background_params)
    if @productbg.save
      flash[:notice] = 'Загружено успешно'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @productbg = ::Lists::ProductBackground.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @productbg = ::Lists::ProductBackground.find(params[:id])
    if @productbg.update_attributes(product_background_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    ::Lists::ProductBackground.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  private
  
  def product_background_params
    params.require(:productbg).permit(:title, 
                                      :image, 
                                      :image_cache)
  end

end
