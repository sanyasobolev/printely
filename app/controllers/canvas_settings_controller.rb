class CanvasSettingsController < ApplicationController

  skip_before_filter :authorized?,
                     :only => [:show]
  
  def show
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
