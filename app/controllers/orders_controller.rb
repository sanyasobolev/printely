# encoding: utf-8
class OrdersController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:index, :my, :new, :create, :remove, :show]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]

  def index

  end

  def my
    @title = 'Мои заказы'
    @orders = Order.where(:user_id => current_user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @orders }
    end
  end

  def new_uploader
    @order = Order.new
    gon.print_format_array = Document::PRINT_FORMAT
    gon.paper_type_array = Document::PAPER_TYPE
    gon.margins_array = Document::MARGINS
    respond_to do |format|
      format.html
      format.json{ render json @document }
    end
  end

  def new
    @order = Order.new
    respond_to do |format|
      format.html
      format.js
    end
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
    @title = "Редактирование заказа №#{@order.id}"
  end

  def update
    @order = Order.find(params[:id])
    respond_to do |wants|
      if @order.update_attributes(params[:order])
        flash[:notice] = 'Заказ обновлен'
        wants.html { redirect_to admin_orders_path }
        wants.xml { render :xml => @order.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => @order.errors}
      end
    end
  end




  def remove
    respond_to do |format|
      format.js
    end
  end

  def show
    @order = Order.find_by_id(params[:id])
    @title = "Заказ № #{@order.id}"
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @order.to_xml }
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
