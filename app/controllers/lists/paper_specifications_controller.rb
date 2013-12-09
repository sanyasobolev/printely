# encoding: utf-8
class Lists::PaperSpecificationsController < ApplicationController
  def index
    @title = 'Спецификации бумаги'
    @pspecs = Lists::PaperSpecification.joins(:paper_size).order('lists_paper_sizes.size')
  end

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
      redirect_to :action => 'index'
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
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::PaperSpecification.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  
end
