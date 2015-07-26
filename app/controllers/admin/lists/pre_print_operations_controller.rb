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
    if @operation.update_attributes(params[:operation])
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
    @operation = ::Lists::PrePrintOperation.new(params[:operation])
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

end
