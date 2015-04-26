# encoding: utf-8
class OrdersController < ApplicationController
  layout 'order', :only => [:index, :my, :show]
  
  before_filter :find_order,
                :only => [:edit_documents,
                          :update_documents,
                          :edit_delivery,
                          :update_delivery,
                          :edit_status,
                          :update_status, 
                          :cover,
                          :get_materials
                         ]
  
  skip_before_filter :authorized?,
                     :only => [:index, 
                               :my, 
                               :new, 
                               :show, 
                               :destroy, 
                               :set_documents_price, 
                               :set_delivery_price
                               ]

  before_filter :your_order?,
                :only => [:show,
                          :destroy,
                          :set_documents_price,
                          :set_delivery_price
                          ]

  skip_before_filter :verify_authenticity_token,
                     :only => [:new, 
                               :edit_documents,
                               :update_documents,
                               :edit_delivery,
                               :update_delivery,
                               :edit_status,
                               :update_status, 
                               :show
                               ]

  def index
    @title = 'Личный кабинет'
  end

  def my
    @title = 'Мои заказы'
    
    @draft_orders = Order.where(:order_status_id => get_status_id_from_key(10), :user_id => current_user.id)
    @draft_orders.each do |draft_order|
      draft_order.documents.destroy_all
      remove_dir(draft_order.id)
    end
    @draft_orders.destroy_all
        
    @my_orders = Order.where("user_id=#{current_user.id}", :include => :user).order('created_at DESC').page(params[:my_orders_page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @orders }
    end
  end

  def new #create empty order and redirect to wizard
    @order = Order.new(:order_type_id => Lists::OrderType.where(:title => params[:order_type]).first.id)
    @order.set_status(10)
    current_user.orders << @order
      if @order.save(:validate => false)
        session[:order_id] = @order.id #сохраняем id заказа в сессии
        redirect_to order_steps_path(:documents) #редирект на визард
      end
  end

  def edit_documents
    @title = "Редактирование заказа №#{@order.id}"
    @upload_button = 'icons/plus_double_large.png'
    respond_to do |format|
      case @order.order_type.title
      when 'foto_print'
        @js_libraries = [
              "orders/uploadfn",
              "orders/foto_print_order_documents"
              ]  
        @partial = 'orders/foto_print/filelist'
        format.html { render layout: "order_steps"}
      when 'doc_print'
        @js_libraries = [
              "orders/uploadfn",
              "orders/doc_print_order_documents"
              ] 
        @partial = 'orders/doc_print/filelist'
        format.html { render layout: "order_steps"}
      when 'envelope_print'
          flash[:error] = 'Редактирование недоступно.'
          format.html { redirect_to admin_orders_path }
      end
    end
  end

  def update_documents
    @order.update_attribute(:cost, @order.documents_price+@order.delivery_price)
    respond_to do |wants|
      flash[:notice] = 'Заказ обновлен.'
      wants.html { redirect_to admin_orders_path }
      wants.xml { render :xml => @order.to_xml }
    end
  end
  
  def edit_delivery
    @title = "Редактирование доставки заказа №#{@order.id}"
    @js_libraries = [
              "orders/uploadfn",
              "orders/deliveryfn",
              "orders/calendarfn",
              "orders/order_delivery",
              ]
    gon.delivery_dates = @order.user.get_delivery_dates(@order) #get dates of delivery for user order
    #рендер view в зависимости от типа заказа
    respond_to do |format|
      format.html { render layout: "order_steps"} 
    end
  end
  
  def update_delivery
    @order.update_attributes(
        :delivery_town_id => params[:order][:delivery_town_id], 
        :delivery_street => params[:order][:delivery_street], 
        :delivery_address => params[:order][:delivery_address], 
        :delivery_date => params[:order][:delivery_date])
    if params[:order][:delivery_start_time] == ""
         params[:order][:delivery_start_time] = Order::DEFAULT_START_TIME
    end
    if params[:order][:delivery_end_time] == ""
         params[:order][:delivery_end_time] = Order::DEFAULT_END_TIME
    end
    if params[:order][:delivery_start_time] && params[:order][:delivery_end_time]
       @order.update_attributes(
                :delivery_start_time => params[:order][:delivery_start_time], 
                :delivery_end_time => params[:order][:delivery_end_time])
    end
    @order.update_attribute(:cost, @order.documents_price+@order.delivery_price)
    respond_to do |wants|
      flash[:notice] = 'Заказ обновлен.'
      wants.html { redirect_to admin_orders_path }
      wants.xml { render :xml => @order.to_xml }
    end
  end
  
  def edit_status
    @title = "Обновление статуса заказа №#{@order.id}"
    respond_to do |format|
      format.html 
    end
  end
  
  def update_status
    @order.update_attribute(:manager_comment, params[:order][:manager_comment]) if params[:order][:manager_comment]

    old_status_key = @order.order_status.key
    new_status_key = params[:order][:order_status_id].nil? ? old_status_key : get_status_key_from_id(params[:order][:order_status_id])
      if new_status_key!=old_status_key #отправка сообщения на почту пользователя, ели статус был изменен
        @order.update_attribute(:order_status_id, get_status_id_from_key(new_status_key))
        case new_status_key
        when 50 #order complete
          UserMailer.email_user_about_complete_order(@order).deliver
        when 10 #order remove
          UserMailer.email_user_about_remove_order(@order).deliver
        else #change status
          UserMailer.email_user_about_change_status(@order).deliver
        end
      end
    respond_to do |wants|
      flash[:notice] = 'Заказ обновлен.'
      wants.html { redirect_to admin_orders_path }
      wants.xml { render :xml => @order.to_xml }     
    end
  end

  def show
    @title = "Заказ №#{@order.id}"
    respond_to do |format|
      case @order.order_type.title
        when 'foto_print'
          @partial = 'orders/foto_print/show_filelist'
          format.html { render 'orders/share/show' }
        when 'doc_print'
          @partial = 'orders/doc_print/show_filelist'
          format.html { render 'orders/share/show' }
        when 'envelope_print'
           @partial = 'orders/envelope_print/show_filelist'
           @document = @order.documents.first 
           format.html { render 'orders/share/show' }
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

  def admin
    @title = "Управление заказами"
    if params[:q]
      @search = Order.search(params[:q]) 
    else
      @search = Order.search(:order_status_key_not_eq => 10) 
    end
    @search.sorts = 'id desc' if @search.sorts.empty?
    @orders = @search.result.page(params[:page])
    @search.build_condition
  end

  def cover
    @title = "Заказ № #{@order.id}"
    @format = params[:format]
    @documents_quantity = 0
    @order.documents.each do |document|
      @documents_quantity = @documents_quantity + document.quantity.to_i 
    end
    render layout: "cover_for_order"
  end
  
  def get_materials
     @title = "Использование материалов в заказе №#{@order.id}"
     @lines = @order.get_document_specification #получаем список всех типоразмеров бумаги с количеством
     render layout: "cover_for_order"
  end

 def set_delivery_price
    @order.update_attribute(:delivery_type, params[:delivery_type]) if params[:delivery_type]
    @order.update_attribute(:delivery_date, params[:delivery_date]) if params[:delivery_date]
    @order.update_attribute(:delivery_town_id, params[:delivery_town]) if params[:delivery_town]

    update_delivery_price(@order)
    respond_to do |format|
        format.js { render 'orders/share/delivery_price'}
    end
 end

 def set_documents_price
    update_documents_price(@order)
    respond_to do |format|
        format.js { render 'orders/share/documents_price'}
    end
 end

  private
  
  def find_order
    @order = Order.find_by_id(params[:id])
  end
  
  def update_documents_price(order)
    documents_price = 0
    if order.documents.size > 0
      order.documents.each do |document|
        (documents_price = documents_price + document.cost) unless document.cost.nil?
      end
    end  
    order.update_attribute(:documents_price, documents_price)
  end  

  def update_delivery_price(order)
      if order.delivery_type == 'Курьер'
        #ищем цену доставки в прайсе и проверяем есть ли уже заказы на дату
        if order.user.get_delivery_dates(order).include?(order.delivery_date)
          delivery_price = 0
        else
          delivery_price = order.delivery_town.nil? ? order.delivery_price : order.delivery_town.delivery_zone.price
        end
      else
        delivery_price = 0
      end
      order.update_attribute(:delivery_price, delivery_price)
  end

  def remove_dir(order_id) #delete order folder
    FileUtils.remove_dir("#{Rails.root}/public/uploads/order_#{order_id}", :force => true)
  end
    
  def get_status_id_from_key(key)
    Lists::OrderStatus.where(:key => key).first.id
  end
    
  def get_status_key_from_id(id)
    Lists::OrderStatus.where(:id => id).first.key
  end

end

