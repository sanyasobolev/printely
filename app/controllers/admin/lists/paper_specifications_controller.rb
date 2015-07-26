# encoding: utf-8
class Admin::Lists::PaperSpecificationsController < ApplicationController

  def index
    @title = 'Спецификации бумаги'
    @pspecs = ::Lists::PaperSpecification.all
  end
  
  def new
    @title = 'Создание'
    @pspec = ::Lists::PaperSpecification.new
  end

  def create
    @pspec = ::Lists::PaperSpecification.new(params[:pspec])
    if @pspec.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @pspec = ::Lists::PaperSpecification.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @pspec = ::Lists::PaperSpecification.find(params[:id])
    if @pspec.update_attributes(params[:pspec])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    ::Lists::PaperSpecification.find(params[:id]).destroy
    redirect_to :action => 'index'
  end


end
