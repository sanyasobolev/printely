# encoding: utf-8
class Lists::PaperTypesController < ApplicationController
 def index
    @title = 'Типы бумаги'
    @paper_types = Lists::PaperType.all
  end

  def edit
    @paper_type = Lists::PaperType.find(params[:id])
    @title = "Редактирование - #{@paper_type.paper_type}"
  end

  def update
    @paper_type = Lists::PaperType.find(params[:id])
    if @paper_type.update_attributes(params[:paper_type])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание нового типа'
    @paper_type = Lists::PaperType.new
  end

  def create
    @paper_type = Lists::PaperType.new(params[:paper_type])
    if @paper_type.save
      flash[:notice] = 'Тип создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::PaperType.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

end
