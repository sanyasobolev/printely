# encoding: utf-8
class Lists::PaperSpecificationsController < ApplicationController

  def edit
    @pspec = Lists::PaperSpecification.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @pspec = Lists::PaperSpecification.find(params[:id])
    @pspec.document_specifications.each do |document_specification|
      document_specification.update_attribute("available", params[:pspec][:in_stock])
    end    
    if @pspec.update_attributes(params[:pspec])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'admin'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @pspec = Lists::PaperSpecification.new
  end

  def create
    @pspec = Lists::PaperSpecification.new(params[:pspec])
    if @pspec.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'admin'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::PaperSpecification.find(params[:id]).destroy
    redirect_to :action => 'admin'
  end

  def admin
    @title = 'Спецификации бумаги'
    @pspecs = Lists::PaperSpecification.all
  end
  
end
