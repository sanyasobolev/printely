# encoding: utf-8
class ProductBackgroundsController < ApplicationController
  before_filter :login_required
  
  def load_image
    @order = Order.find(params[:order_id])
    
    respond_to do |format|
        format.html do
          render :partial => 'item' 
        end
    end
  end

end
