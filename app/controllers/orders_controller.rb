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

  def new
      @order = Order.new
      5.times{@order.documents.build}
    respond_to do |format|
      format.html
      format.js
    end
  end

  def no_order

  end

  def create
    @order = Order.new(params[:order])
    current_user.orders << @order
    respond_to do |wants|
        if @order.save
          flash[:notice] = 'Заказ создан успешно.'
          wants.html {redirect_to my_orders_path}
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "new" }
          wants.xml {render :xml => @order.errors}
        end
      end
  end

  def edit
    @order = Order.find(params[:id])

  end
end
