# encoding: utf-8
class ProductBackgroundsController < ApplicationController

  skip_before_filter :authorized?,
                     :only => [:load_image]
  
  def load_image
    @pspec = Lists::PaperSpecification.where(["paper_type_id = ? and paper_size_id = ?", params[:selected_paper_type].to_i, params[:selected_paper_size].to_i]).first
    @item = ''

    if @pspec.product_backgrounds.empty?
      @item = "Нет изображения макета."
    else
      @item = "<img src='"+"#{@pspec.product_backgrounds.first.image_url}"+"'>"
    end
    
    respond_to do |format|
        format.html do
          render :partial => 'item' 
        end
    end
  end

end
