class CanvasSettingsController < ApplicationController
  
  before_filter :login_required
  
  def show
    @pspec = Lists::PaperSpecification.find_paper_specification(params[:selected_paper_size], params[:selected_paper_type])
    @canvas_settings = @pspec.canvas_settings.empty? ? '' : @pspec.canvas_settings.first

    respond_to do |format|
       format.json { render json: @canvas_settings }
    end
  end
  
end
