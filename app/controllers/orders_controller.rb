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
      @page_about_download = Page.find_by_id('3', :conditions => "published=true")
      flash[:page_about_download] = @page_about_download
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @order = Order.new(params[:order]) #создаем экземпляр с атрибутами из хэша
    @page_about_download = flash[:page_about_download]
    current_user.orders << @order
    respond_to do |wants|
      if @order.save #если создано предложение
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
