# encoding: utf-8
class Lists::DocumentSpecificationsController < ApplicationController
  
  def index
    @title = 'Спецификации готовых документов'
    @dspecs = Lists::DocumentSpecification.joins(:paper_specification => :paper_size).order('lists_paper_sizes.size').joins(:paper_specification => :paper_type).order('lists_paper_types.paper_type')
    #@dspecs = Lists::DocumentSpecification.joins(:paper_specification => :paper_type).where("lists_paper_types.paper_type = 'Глянцевая'").joins(:paper_specification => :paper_size).where("lists_paper_sizes.size = '10x15'").joins(:print_margin).where("lists_print_margins.margin = 'Без полей'")
  end

  def edit
    @dspec = Lists::DocumentSpecification.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @dspec = Lists::DocumentSpecification.find(params[:id])
    if @dspec.update_attributes(params[:dspec])
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'index'
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
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::DocumentSpecification.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
  

end
