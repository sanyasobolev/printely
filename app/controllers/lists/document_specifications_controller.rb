# encoding: utf-8
class Lists::DocumentSpecificationsController < ApplicationController
  
  def edit
    @dspec = Lists::DocumentSpecification.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @dspec = Lists::DocumentSpecification.find(params[:id])
    if @dspec.update_attributes(params[:dspec])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'admin'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @dspec = Lists::DocumentSpecification.new
  end

  def create
    @dspec = Lists::DocumentSpecification.new(params[:dspec])
    if @dspec.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'admin'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::DocumentSpecification.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  def admin
    @title = 'Спецификации готовых документов'
    @dspecs = Lists::DocumentSpecification.admin_order
  end

end
