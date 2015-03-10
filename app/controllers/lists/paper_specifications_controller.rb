# encoding: utf-8
class Lists::PaperSpecificationsController < ApplicationController

  skip_before_filter :authorized?,
                     :only => [:get_layout, :get_canvas_settings]


  def edit
    @pspec = Lists::PaperSpecification.find(params[:id])
    @title = "Редактирование"
  end

  def update
    @pspec = Lists::PaperSpecification.find(params[:id])
    if @pspec.update_attributes(params[:pspec])
      if params[:pspec][:remove_layout] == '1' #delete folder
        FileUtils.remove_dir("#{Rails.root}/public/layouts/#{@pspec.paper_size.size.parameterize}_#{@pspec.paper_type.paper_type.parameterize}", :force => true)
      end
      flash[:notice] = 'Обновление прошло успешно.'
      redirect_to :action => 'admin'
    else
      render :action => 'edit'
    end
  end

  def new
    @title = 'Создание'
    @pspec = Lists::PaperSpecification.new
  end

  def create
    @pspec = Lists::PaperSpecification.new(params[:pspec])
    if @pspec.save
      flash[:notice] = 'Параметр создан удачно.'
      redirect_to :action => 'admin'
    else
      render :action => 'new'
    end
  end

  def destroy
    Lists::PaperSpecification.find(params[:id]).destroy
    redirect_to :action => 'admin'
  end

  def admin
    @title = 'Спецификации бумаги'
    @pspecs = Lists::PaperSpecification.all
  end
  
  def get_layout
    @pspec = Lists::PaperSpecification.where(["paper_type_id = ? and paper_size_id = ?", params[:selected_paper_type].to_i, params[:selected_paper_size].to_i]).first
    @item = ''

    if !@pspec.layout?
      @item = "Нет изображения макета."
    else
      @item = "<img src='"+"#{@pspec.layout_url}"+"'>"
    end
    
    respond_to do |format|
        format.html do
          render :partial => 'item' 
        end
    end
  end
  
  def get_canvas_settings
    @pspec = Lists::PaperSpecification.where(["paper_type_id = ? and paper_size_id = ?", params[:selected_paper_type].to_i, params[:selected_paper_size].to_i]).first
    
    if @pspec.canvas_settings.empty?
      @canvas_settings = ''
    else
      @canvas_settings = @pspec.canvas_settings.first
    end

    respond_to do |format|
       format.json { render json: @canvas_settings }
    end
  end


  
end
