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
    @pspec = ::Lists::PaperSpecification.new(paper_specification_params)
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
    if @pspec.update_attributes(paper_specification_params)
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

  private
  
  def paper_specification_params
    params.require(:pspec).permit(:paper_type_id, 
                                  :paper_size_id, 
                                  :in_stock, 
                                  :price, 
                                  :order_type_id,
                                  :canvas_setting_ids,
                                  :product_background_ids)
  end

end
