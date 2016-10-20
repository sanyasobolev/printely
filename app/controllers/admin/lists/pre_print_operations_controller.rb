# encoding: utf-8
class Admin::Lists::PrePrintOperationsController < ApplicationController

  def index
    @title = 'Допечатные операции'
    @operations = ::Lists::PrePrintOperation.all
  end

  def edit
    @operation = ::Lists::PrePrintOperation.find(params[:id])
    @title = "Редактирование операции - #{@operation.operation}"
  end

  def update
    @operation = ::Lists::PrePrintOperation.find(params[:id])
    if @operation.update_attributes(pre_print_operation_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание новой операции'
    @operation = ::Lists::PrePrintOperation.new
  end

  def create
    @operation = ::Lists::PrePrintOperation.new(pre_print_operation_params)
    if @operation.save
      flash[:notice] = 'Операция создана удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::PrePrintOperation.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  private
  
  def pre_print_operation_params
    params.require(:operation).permit(:operation, :price, :order_type_id)
  end

end
