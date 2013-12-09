# encoding: utf-8
class Lists::PrintMarginsController < ApplicationController
    
  def index
    @title = 'Поля и отступы'
    @margins = Lists::PrintMargin.all
  end

  def edit
    @margin = Lists::PrintMargin.find(params[:id])
    @title = "Редактирование - #{@margin.margin}"
  end

  def update
    @margin = Lists::PrintMargin.find(params[:id])
    if @margin.update_attributes(params[:margin])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @margin = Lists::PrintMargin.new
  end

  def create
    @margin = Lists::PrintMargin.new(params[:margin])
    if @margin.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::PrintMargin.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  
end
