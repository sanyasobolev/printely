# encoding: utf-8
class RightsController < ApplicationController

  def index
    @title = 'Права ролей пользователей'
  	@rights = Right.all
  end

  def edit
  	@right = Right.find(params[:id])
    @title = "Редактирование права - #{@right.name}"
  end

  def update
  	@right = Right.find(params[:id])
  	if @right.update_attributes(params[:right])
  		flash[:notice] = 'Обновление прошло успешно.'
  		redirect_to :action => 'index'
  	else
  		render :action => 'edit'
  	end
  end

  def new
    @title = 'Создание нового права'
  	@right = Right.new
  end

  def create
  	@right = Right.new(params[:right])
  	if @right.save
  		flash[:notice] = 'Право создано удачно.'
  		redirect_to :action => 'index'
  	else
      render :action => 'new'
  	end
  end

  def destroy
  	Right.find(params[:id]).destroy
  	redirect_to :action => 'index'
  end

end
