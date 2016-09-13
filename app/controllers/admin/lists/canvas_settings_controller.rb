# encoding: utf-8
class Admin::Lists::CanvasSettingsController < ApplicationController
  def index
    @title = 'Настройки canvas'
    @canvas_settings = ::Lists::CanvasSetting.all
  end

  def edit
    @canvas_setting = ::Lists::CanvasSetting.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @canvas_setting = ::Lists::CanvasSetting.find(params[:id])
    if @canvas_setting.update_attributes(canvas_setting_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @canvas_setting = ::Lists::CanvasSetting.new
  end

  def create
    @canvas_setting = ::Lists::CanvasSetting.new(canvas_setting_params)
    if @canvas_setting.save
      flash[:notice] = 'Настройка создана удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::CanvasSetting.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  
  private
  
  def canvas_setting_params
    params.require(:canvas_setting).permit(:margin_top,
                                           :margin_left,
                                           :width,
                                           :height)
  end  
  


end
