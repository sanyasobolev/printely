# encoding: utf-8
class Admin::Lists::PrintColorsController < ApplicationController
  def index
    @title = 'Цветность печати'
    @colors = ::Lists::PrintColor.all
  end

  def edit
    @color = ::Lists::PrintColor.find(params[:id])
    @title = "Редактирование - #{@color.color}"
  end

  def update
    @color = ::Lists::PrintColor.find(params[:id])
    if @color.update_attributes(print_color_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @color = ::Lists::PrintColor.new
  end

  def create
    @color = ::Lists::PrintColor.new(print_color_params)
    if @color.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::PrintColor.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  private
  
  def print_color_params
    params.require(:color).permit(:color, :price, :order_type_id)
  end
  
end
