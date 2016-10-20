# encoding: utf-8
class Admin::Lists::DeliveryTownsController < ApplicationController

  def index
    @title = 'Населенные пункты'
    @delivery_towns = ::Lists::DeliveryTown.all
  end

  def edit
    @delivery_town = ::Lists::DeliveryTown.find(params[:id])
    @title = "Редактирование - #{@delivery_town.title}"
  end

  def update
    @delivery_town = ::Lists::DeliveryTown.find(params[:id])
    if @delivery_town.update_attributes(delivery_town_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Добавление населенного пункта'
    @delivery_town = ::Lists::DeliveryTown.new
  end

  def create
    @delivery_town = ::Lists::DeliveryTown.new(delivery_town_params)
    if @delivery_town.save
      flash[:notice] = 'Населенный пункт создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::DeliveryTown.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  private
  
  def delivery_town_params
    params.require(:delivery_town).permit(:title, :delivery_zone_id)
  end  
  
    

end
