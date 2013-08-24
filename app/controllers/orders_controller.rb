# encoding: utf-8
class OrdersController < ApplicationController
  layout 'orders_boardlinks', :only => [:index, :my, :show]

  skip_before_filter :authorized?,
                     :only => [:index, :my, :new, :show, :edit, :update, :destroy, :ajaxupdate]

  skip_before_filter :verify_authenticity_token,
                     :only => [:new, :edit, :update, :show]

  before_filter :your_order?,
                :only => [:edit, :show, :destroy, :ajaxupdate]

  def index

  end

  def my
    @title = 'Мои заказы'
    @draft_orders = Order.where(:status => Order::STATUS[0])
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
    @order = Order.new(:status => Order::STATUS[0])
    order_set_price
    current_user.orders << @order
    respond_to do |wants|
        if @order.save(:validate => false)
          wants.html {redirect_to edit_order_path(@order)}
          wants.xml { render :xml => @order.to_xml }
        end
      end
  end

  def edit
    if current_user.has_role?('Administrator')
      @title = "Обновление заказа №#{@order.id}"
      render 'adminedit'
    else
      if @order.status == Order::STATUS[0]
        @title = "Заказ №#{@order.id}"
        render 'edit'
      else
        flash[:error] = 'Вы не можете редактировать созданный ранее заказ.'
        redirect_to my_orders_path
      end
    end
  end

  def update
    @order = Order.find(params[:id])
    if current_user.has_role?('Administrator') # если администратор или менеджер
      old_status = @order.status
      respond_to do |wants|
        if @order.update_attributes(params[:order])
          new_status = @order.status
          if new_status != old_status #отправка сообщения на почту пользователя, ели статус был изменен
            if new_status == 'выполнен'
              UserMailer.email_user_about_complete_order(@order).deliver
            else
              UserMailer.email_user_about_change_status(@order).deliver
            end
          end
          flash[:notice] = 'Заказ обновлен.'
          wants.html { redirect_to admin_orders_path }
          wants.xml { render :xml => @order.to_xml }
        else
          wants.html { render :action => "adminedit" }
          wants.xml {render :xml => @order.errors}
        end
      end
    else #если обычный пользователь
      if (@order.documents.length == 0 || params[:order][:delivery_street] == "" || params[:order][:delivery_address] == "" || params[:order][:delivery_date] == "")
        flash[:error] = 'Для оформления заказа необходимо загрузить хотя бы один файл и заполнить информацию о доставке.'
        render :action => "edit"
      else
        @order.documents.each do |document|
          document.update_attributes(params[:order][:documents_attributes][document.id.to_s])
        end
        if params[:order][:delivery_start_time] == ""
          params[:order][:delivery_start_time] = Order::DEFAULT_START_TIME
        end
        if params[:order][:delivery_end_time] == ""
          params[:order][:delivery_end_time] = Order::DEFAULT_END_TIME
        end
         if @order.update_attributes(:delivery_street => params[:order][:delivery_street], :delivery_address => params[:order][:delivery_address], :delivery_date => params[:order][:delivery_date], :delivery_start_time => params[:order][:delivery_start_time], :delivery_end_time => params[:order][:delivery_end_time], :status => Order::STATUS[1], :created_at => Time.now)
          UserMailer.email_all_admins_about_new_order(@order)
          UserMailer.email_user_about_new_order(@order).deliver
          flash[:notice] = 'Спасибо! Заказ создан. В ближайшее время мы свяжемся с вами.'
          redirect_to my_orders_path
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
    @order.documents.each do |document|
      document.remove_docfile!
    end
    @order.destroy
    respond_to do |wants|
      wants.html { redirect_to myoffice_path }
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

  def ajaxupdate
    if params[:delivery_type]
      @order.update_attribute(:delivery_type, params[:delivery_type])
    end
    order_set_price
    respond_to do |format|
        format.js
      end
  end

  def cover
    @order = Order.find_by_id(params[:id])
    @title = "Заказ № #{@order.id}"
    @format = params[:format]
    @documents_quantity = 0
    @order.documents.each do |document|
      @documents_quantity = @documents_quantity + document.quantity.to_i 
    end
    render layout: "cover_for_order"
  end

  private
  def order_set_price
    if @order.delivery_type
      #ищем цену доставки в прайсе
      delivery_price = PricelistDelivery.where(:delivery_type => @order.delivery_type).first.price
    else
      delivery_price = 0
    end
    @order.update_attribute(:delivery_price, delivery_price)

    #считаем стоимость всех документов
    documents_cost = 0
    if @order.documents.length > 0
      @order.documents.each do |document|
        documents_cost = documents_cost + document.price
      end
    end
    order_cost = @order.delivery_price + documents_cost
    @order.update_attribute(:cost, order_cost)
  end
end

