class OrdersController < ApplicationController

  def index

  end

  def my
    @title = 'Мои заказы'
  	@orders = Order.where(:user_id => current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
    end
  end

  def upload_files
      @order = Order.new
      5.times{@order.documents.build}
      session[:save_documents]=true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def delivery
    if session[:documents_saved] == true
      @order = Order.find(session[:created_order_id])
      session[:save_delivery]=true #для проверки, что user был на странице доставки
      session[:documents_saved]=false
    else
      redirect_to no_order_orders_path
      return
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def no_order

  end

  def create
    if session[:save_documents] == true
      @order = Order.new(params[:order])
      current_user.orders << @order
    respond_to do |wants|
        if @order.save
          session[:save_documents] = false
          session[:documents_saved] = true
          session[:created_order_id] = @order.id
          wants.html {redirect_to delivery_orders_path}
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "upload_files" }
          wants.xml {render :xml => @order.errors}
        end
      end
    elsif session[:save_delivery] == true
      @order = Order.find(session[:created_order_id])
      respond_to do |wants|
        if @order.update_attributes(params[:order])
          flash[:notice] = 'Заказ создан успешно.'
          session[:save_delivery]=false
          wants.html {redirect_to my_orders_path}
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "delivery" }
          wants.xml {render :xml => @order.errors}
        end
      end
    else

    end
  end

  def edit
    @order = Order.find(params[:id])

  end
end
