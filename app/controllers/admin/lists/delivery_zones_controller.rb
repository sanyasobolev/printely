# encoding: utf-8
class Admin::Lists::DeliveryZonesController < ApplicationController

  def index
    @title = 'Зоны доставки'
    @delivery_zones = ::Lists::DeliveryZone.all
  end

  def edit
    @delivery_zone = ::Lists::DeliveryZone.find(params[:id])
    @title = "Редактирование - #{@delivery_zone.title}"
  end

  def update
    @delivery_zone = ::Lists::DeliveryZone.find(params[:id])
    if @delivery_zone.update_attributes(params[:delivery_zone])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание новой зоны доставки'
    @delivery_zone = ::Lists::DeliveryZone.new
  end

  def create
    @delivery_zone = ::Lists::DeliveryZone.new(params[:delivery_zone])
    if @delivery_zone.save
      flash[:notice] = 'Зона создана удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::DeliveryZone.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
    

end
