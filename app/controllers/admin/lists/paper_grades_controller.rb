# encoding: utf-8
class Admin::Lists::PaperGradesController < ApplicationController
 def index
    @title = 'Классы бумаги'
    @grades = ::Lists::PaperGrade.all
  end

  def edit
    @grade = ::Lists::PaperGrade.find(params[:id])
    @title = "Редактирование класса  #{@grade.grade}"
  end

  def update
    @grade = ::Lists::PaperGrade.find(params[:id])
    if @grade.update_attributes(params[:grade])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание нового класса'
    @grade = ::Lists::PaperGrade.new
  end

  def create
    @grade = ::Lists::PaperGrade.new(params[:grade])
    if @grade.save
      flash[:notice] = 'Класс создан удачно.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    ::Lists::PaperGrade.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  
end
