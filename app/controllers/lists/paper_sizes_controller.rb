# encoding: utf-8
class Lists::PaperSizesController < ApplicationController
  
  def index
    @title = 'Размеры бумаги'
    @sizes = Lists::PaperSize.all
  end

  def edit
    @size = Lists::PaperSize.find(params[:id])
    @title = "Редактирование - #{@size.size}"
  end

  def update
    @size = Lists::PaperSize.find(params[:id])
    if @size.update_attributes(params[:size])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @size = Lists::PaperSize.new
  end

  def create
    @size = Lists::PaperSize.new(params[:size])
    if @size.save
      flash[:notice] = 'Размер создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::PaperSize.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  
end
