# encoding: utf-8
class Admin::Lists::PaperDensitiesController < ApplicationController
  def index
    @title = 'Плотности бумаги'
    @densities = ::Lists::PaperDensity.all
  end

  def edit
    @density = ::Lists::PaperDensity.find(params[:id])
    @title = "Редактирование - #{@density.density}"
  end

  def update
    @density = ::Lists::PaperDensity.find(params[:id])
    if @density.update_attributes(paper_density_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @density = ::Lists::PaperDensity.new
  end

  def create
    @density = ::Lists::PaperDensity.new(paper_density_params)
    if @density.save
      flash[:notice] = 'Плотность бумаги создана удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::PaperDensity.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  private
  
  def paper_density_params
    params.require(:density).permit(:density)
  end
  
end
