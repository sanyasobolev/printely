# encoding: utf-8
class OrdersController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:index, :my, :new, :show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create, :update]

  before_filter :your_order?,
                :only => [:edit, :show, :destroy]

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
    gon.order_id = @order.id
    if current_user.has_role?('Administrator')
      @title = "Обновление заказа №#{@order.id}"
      render 'adminedit'
    else
      @title = "Создание заказа №#{@order.id}"
      render 'edit'
    end
  end

  def update
    @order = Order.find(params[:id])
    if current_user.has_role?('Administrator')
      respond_to do |wants|
        if @order.update_attributes(params[:order])
          flash[:notice] = 'Заказ обновлен.'
          wants.html { redirect_to admin_orders_path }
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "adminupdate" }
          wants.xml {render :xml => @order.errors}
        end
      end
    else
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
    end


  def show
    @title = "Заказ № #{@order.id}"
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @order.to_xml }
    end
  end

  def destroy
    @order.destroy
    respond_to do |wants|
      wants.html { redirect_to myoffice_path }
      wants.js  
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

