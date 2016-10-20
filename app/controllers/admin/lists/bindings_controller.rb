# encoding: utf-8
class Admin::Lists::BindingsController < ApplicationController
 def index
    @title = 'Переплет'
    @bindings = ::Lists::Binding.all
  end

  def edit
    @binding = ::Lists::Binding.find(params[:id])
    @title = "Редактирование - #{@binding.binding}"
  end

  def update
    @binding = ::Lists::Binding.find(params[:id])
    if @binding.update_attributes(binding_params)
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @binding = ::Lists::Binding.new
  end

  def create
    @binding = ::Lists::Binding.new(binding_params)
    if @binding.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::Binding.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
  private
  
  def binding_params
    params.require(:binding).permit(:binding, :price)
  end
  
end
