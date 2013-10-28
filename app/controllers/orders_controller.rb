# encoding: utf-8
class OrdersController < ApplicationController
  layout 'orders_boardlinks', :only => [:index, :my, :show]

  skip_before_filter :authorized?,
                     :only => [:index, :my, :new_print, :new_scan, :show, :edit, :update, :destroy, :ajaxupdate]

  skip_before_filter :verify_authenticity_token,
                     :only => [:new_print, :edit, :update, :show]

  before_filter :your_order?,
                :only => [:edit, :show, :destroy, :ajaxupdate]

  def index

  end

  def my
    @title = 'Мои заказы'
    
    @draft_orders = Order.where(:status => Order::STATUS[0], :user_id => current_user.id)
    @draft_orders.each do |draft_order|
      draft_order.documents.destroy_all
      remove_dir(draft_order.id)
    end
    @draft_orders.destroy_all
        
    @print_orders = Order.where("user_id=#{current_user.id} AND order_type='print'", :include => :user).order('created_at DESC')
    @scan_orders = Order.where("user_id=#{current_user.id} AND order_type='scan'", :include => :user).order('created_at DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @orders }
    end
  end

  def new_print #create empty order and redirect to edit it
    @order = Order.new(:status => Order::STATUS[0], :order_type => 'print')
    order_set_price
    current_user.orders << @order
    respond_to do |wants|
        if @order.save(:validate => false)
          wants.html {redirect_to edit_order_path(@order)}
          wants.xml { render :xml => @order.to_xml }
        end
      end
  end
  
  def new_scan 
    @order = Order.new(:status => Order::STATUS[0], :order_type => 'scan')
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
    #проверка роли
    if current_user.has_role?('Administrator')
      @title = "Обновление заказа №#{@order.id}"
      @admin_edit = true
    else 
      @title = "Заказ №#{@order.id}"
      @admin_edit = false
    end
    #проверка возможности редактировать заказ
    if @order.status == Order::STATUS[0] || @admin_edit == true
      user_can_edit = true
    else
      user_can_edit = false
    end

    #рендер view в зависимости от типа заказа
    respond_to do |format|
      case @order.order_type
      when 'print'
        if user_can_edit == true
          format.html { render :new_print } 
        else
          flash[:error] = 'Вы не можете редактировать созданный ранее заказ.'
          format.html { redirect_to my_orders_path}
        end
      when 'scan'
        if @admin_edit == true
          format.html { render :admin_edit_scan }
        elsif user_can_edit == true
          format.html { render :new_scan }
        else
          flash[:error] = 'Вы не можете редактировать созданный ранее заказ.'
          format.html { redirect_to my_orders_path}      
        end
      end 
    end
  end

  def update
    @order = Order.find(params[:id])
    if current_user.has_role?('Administrator')  # если администратор или менеджер
      old_status = @order.status
      new_status = params[:order][:status]
      if attr_update(@order, new_status) 
        respond_to do |wants|
          if @order.update_attributes(:manager_comment => params[:order][:manager_comment])
            if new_status != old_status #отправка сообщения на почту пользователя, ели статус был изменен
              if new_status == Order::STATUS[4]
                UserMailer.email_user_about_complete_order(@order).deliver
              elsif new_status == Order::STATUS[0]
                UserMailer.email_user_about_remove_order(@order).deliver
              else
                UserMailer.email_user_about_change_status(@order).deliver
              end
            end
            flash[:notice] = 'Заказ обновлен.'
            wants.html { redirect_to admin_orders_path }
            wants.xml { render :xml => @order.to_xml }
          else
            wants.html { render :action => "edit" }
            wants.xml {render :xml => @order.errors}
          end
        end
      end
    else #если обычный пользователь
        if attr_update(@order, Order::STATUS[1])
          UserMailer.email_all_admins_about_new_order(@order)
          UserMailer.email_user_about_new_order(@order).deliver
          flash[:notice] = 'Спасибо! Заказ создан. В ближайшее время мы свяжемся с вами.'
          redirect_to my_orders_path
        end
    end
  end

  def attr_update(order, status) #update main user attributes of order
    case order.order_type
    when 'print'
      if (order.documents.length == 0)
        flash[:error] = 'Для оформления заказа необходимо загрузить хотя бы один файл.'
        redirect_to :action => "edit"
        return false
      else
        order.documents.each do |document|
          document.update_attributes(params[:order][:documents_attributes][document.id.to_s])
        end
      end
    when 'scan'
      order.scan.update_attributes(params[:order][:scan_attributes])
    end
    
    if (params[:order][:delivery_street] == "" || params[:order][:delivery_address] == "" || params[:order][:delivery_date] == "")  
        flash[:error] = 'Для оформления заказа необходимо заполнить информацию о доставке.'
        redirect_to :action => "edit"
        return false
      else
        if params[:order][:delivery_start_time] == ""
          params[:order][:delivery_start_time] = Order::DEFAULT_START_TIME
        end
        if params[:order][:delivery_end_time] == ""
          params[:order][:delivery_end_time] = Order::DEFAULT_END_TIME
        end
        if params[:order][:cost]
          order.update_attribute(:cost, params[:order][:cost])
        end
        order.update_attributes(
            :delivery_street => params[:order][:delivery_street], 
            :delivery_address => params[:order][:delivery_address], 
            :delivery_date => params[:order][:delivery_date], 
            :delivery_start_time => params[:order][:delivery_start_time], 
            :delivery_end_time => params[:order][:delivery_end_time],
            :status => status, 
            :created_at => Time.now
            )
        return true
    end
  end

  def show
    @title = "Заказ № #{@order.id}"
    respond_to do |format|
      case @order.order_type
      when 'print'
         format.html { render :show_print_order }
      when 'scan'
         format.html { render :show_scan_order } 
      end
    end
  end

  def destroy
    @order.documents.each do |document|
      document.remove_docfile!
    end
    remove_dir(@order.id)
    @order.destroy
    respond_to do |wants|
      wants.html { redirect_to myoffice_path }
    end
  end

#  def admin
#   @title = "Управление заказами"
#   @orders = params[:status] ? Order.where(:status => params[:status]).order('created_at DESC') : Order.where('status != ?', 'draft').order('created_at DESC')
#   respond_to do |format|
#     format.html
#     format.js
#   end
#  end
  
  def admin
    @title = "Управление заказами"
    @search = Order.search(params[:q])
    @orders = @search.result 
    @search.build_condition
  end

  def ajaxupdate
    if params[:delivery_type]
      @order.update_attribute(:delivery_type, params[:delivery_type])
    end
    order_set_price
    respond_to do |format|
      if @order.cost_min == @order.cost_max || @order.cost_min == nil
         format.js { render :single_cost }
      else
         format.js { render :min_max_cost } 
      end
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
      #cчитаем доставку
      if @order.delivery_type
        #ищем цену доставки в прайсе
        delivery_price = PricelistDelivery.where(:delivery_type => @order.delivery_type).first.price
      else
        delivery_price = 0
      end
      @order.update_attribute(:delivery_price, delivery_price)

      documents_cost = 0
      order_cost_min = 0
      order_cost_max = 0
      order_cost = 0
        
      
      case @order.order_type
      when 'print' #считаем документы, если они есть
        if @order.documents.size > 0
          @order.documents.each do |document|
            documents_cost = documents_cost + document.price
          end
        end
        order_cost = @order.delivery_price + documents_cost
        order_cost_min = order_cost
        order_cost_max = order_cost
      when 'scan' #считаем сканы, если они есть
        if @order.scan
          order_cost_min = @order.scan.cost_min + @order.delivery_price
          order_cost_max = @order.scan.cost_max + @order.delivery_price
          if order_cost_min == order_cost_max && order_cost_min != 0
            order_cost = order_cost_min
          end
        end
      end
     @order.update_attributes(:cost => order_cost ,:cost_min => order_cost_min, :cost_max => order_cost_max)
     end
  
    def remove_dir(order_id) #delete order folder
      FileUtils.remove_dir("#{Rails.root}/public/uploads/order_#{order_id}", :force => true)
    end
  
end

