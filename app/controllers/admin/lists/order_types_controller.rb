# encoding: utf-8
class Admin::Lists::OrderTypesController < ApplicationController

 def index
    @title = 'Системные типы заказов'
    @order_types = ::Lists::OrderType.all
  end

  def edit
    @order_type = ::Lists::OrderType.find(params[:id])
    @title = "Редактирование системного типа - #{@order_type.title}"
  end

  def update
    @order_type = ::Lists::OrderType.find(params[:id])
    if @order_type.update_attributes(params[:order_type])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание нового типа заказа'
    @order_type = ::Lists::OrderType.new
  end

  def create
    @order_type = ::Lists::OrderType.new(params[:order_type])
    if @order_type.save
      flash[:notice] = 'Класс создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end


end
