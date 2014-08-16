# encoding: utf-8
class Lists::OrderStatusesController < ApplicationController

  def index
    @title = 'Статусы заказов'
    @statuses = Lists::OrderStatus.all
  end

  def edit
    @status = Lists::OrderStatus.find(params[:id])
    @title = "Редактирование статуса - #{@status.title}"
  end

  def update
    @status = Lists::OrderStatus.find(params[:id])
    if @status.update_attributes(params[:status])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание нового статуса'
    @status = Lists::OrderStatus.new
  end

  def create
    @status = Lists::OrderStatus.new(params[:status])
    if @status.save
      flash[:notice] = 'Cтатус создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::OrderStatus.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
end
