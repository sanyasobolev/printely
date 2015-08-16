# encoding: utf-8
class ProductBackgroundsController < ApplicationController

  skip_before_filter :authorized?,
                     :only => [:load_image]
  
  def load_image
    @order = Order.find(params[:order_id])
    
    respond_to do |format|
        format.html do
          render :partial => 'item' 
        end
    end
  end

end
