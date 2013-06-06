# encoding: utf-8
class OrdersController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:index, :my, :new, :show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create, :update]

  #Сообщения
  NOT_YOUR_ORDER = 'Заказ принадлежит не Вам. Нет доступа.'

  def index

  end

  def my
    @title = 'Мои заказы'
    @orders = Order.paginate :page => params[:page],
                             :order => 'created_at DESC',
                             :include => :user,
                             :per_page => '10',
                             :conditions => "user_id=#{current_user.id}"
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @orders }
    end
  end

  def new #create empty order and redirect to edit it
   @order = Order.new
    current_user.orders << @order
    respond_to do |wants|
        if @order.save
          wants.html {redirect_to edit_order_path(@order)}
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "new" }
          wants.xml {render :xml => @order.errors}
        end
      end
  end

  def edit
    @order = Order.find(params[:id])
    if your_order?(@order)
      @title = "Создание заказа №#{@order.id}"
    else
      flash[:error] = NOT_YOUR_ORDER
      redirect_to my_orders_path
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.documents.each do |document|
      document.update_attributes(params[:order][:documents_attributes][document.id.to_s])
    end
    respond_to do |wants|
      if @order.update_attribute('delivery_street', params[:order][:delivery_street]) && @order.update_attribute('delivery_address', params[:order][:delivery_address]) && @order.update_attribute('delivery_comment', params[:order][:delivery_comment])
        flash[:notice] = 'Спасибо! Заказ создан. В ближайшее время мы свяжемся с вами.'
        wants.html { redirect_to my_orders_path }
        wants.xml { render :xml => @order.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @order.errors}
      end
    end
  end

  def show
    @order = Order.find_by_id(params[:id])
    if your_order?(@order)
      @title = "Заказ № #{@order.id}"
      respond_to do |wants|
        wants.html
        wants.xml { render :xml => @order.to_xml }
      end
    else
      flash[:error] = NOT_YOUR_ORDER
      redirect_to my_orders_path
    end
  end

  def destroy
    @order = Order.find_by_id(params[:id])
    if your_order?(@order)
      @order.destroy
      respond_to do |wants|
        wants.html { redirect_to myoffice_path }
        wants.xml { render :nothing => true }
      end
    else
      flash[:error] = NOT_YOUR_ORDER
      redirect_to my_orders_path
    end
  end

  def admin
    @title = "Управление заказами"
    @orders = Order.paginate :page => params[:page],
                             :order => 'created_at DESC',
                             :include => :user,
                             :per_page => '50'

    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @services.to_xml }
    end
  end
end
