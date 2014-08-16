# encoding: utf-8
class Lists::PaperSpecificationsController < ApplicationController

  def edit
    @pspec = Lists::PaperSpecification.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @pspec = Lists::PaperSpecification.find(params[:id])
    if @pspec.update_attributes(params[:pspec])
      if params[:pspec][:remove_layout] == '1' #delete folder
        FileUtils.remove_dir("#{Rails.root}/public/layouts/#{@pspec.paper_size.size.parameterize}_#{@pspec.paper_type.paper_type.parameterize}", :force => true)
      end
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
