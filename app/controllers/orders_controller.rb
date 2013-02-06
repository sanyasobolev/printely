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
      @page_about_download = Page.find_by_id('3', :conditions => "published=true")
      flash[:page_about_download] = @page_about_download
      flash[:save_documents]=true #для проверки, что user был на странице загрузки файлов
    respond_to do |format|
      format.html
      format.js
    end
  end

  def delivery
    if flash[:documents_saved] == true
      @order = Order.find(flash[:created_order_id])
      flash[:save_delivery]=true #для проверки, что user был на странице доставки
      flash[:created_order_id] = @order.id
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
    if flash[:save_documents] == true
      @order = Order.new(params[:order])
      @page_about_download = flash[:page_about_download]
      current_user.orders << @order
    respond_to do |wants|
      if @order.save
        wants.html {redirect_to delivery_orders_path, :flash => {:documents_saved => true, :created_order_id => @order.id}}
        wants.xml { render :xml => @order.to_xml }
      else
        wants.html { render :action => "upload_files" }
        wants.xml {render :xml => @order.errors}
      end
    end

    elsif flash[:save_delivery] == true
      @order = Order.find(flash[:created_order_id])
      respond_to do |wants|
        if @order.update_attributes(params[:order])
          flash[:notice] = 'Заказ создан успешно.'
          wants.html {redirect_to my_orders_path}
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "delivery" }
          wants.xml {render :xml => @order.errors}
        end
      end
    end
  end

  def edit
    @order = Order.find(params[:id])

  end
end
