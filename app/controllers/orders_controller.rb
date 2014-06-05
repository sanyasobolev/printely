# encoding: utf-8
class OrdersController < ApplicationController
  layout 'orders_boardlinks', :only => [:index, :my, :show]

  skip_before_filter :authorized?,
                     :only => [:index, :my, :new, :show, :edit, :update, :destroy, :ajaxupdate]

  skip_before_filter :verify_authenticity_token,
                     :only => [:new, :edit, :update, :show]

  before_filter :your_order?,
                :only => [:edit, :show, :destroy, :ajaxupdate, :edit_files, :edit_delivery, :edit_status]

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
        
    @foto_print_orders = Order.where("user_id=#{current_user.id} AND order_type_id=2", :include => :user).order('created_at DESC').page(params[:foto_print_orders_page])
    @doc_print_orders = Order.where("user_id=#{current_user.id} AND order_type_id=3", :include => :user).order('created_at DESC').page(params[:doc_print_orders_page])
    @scan_orders = Order.where("user_id=#{current_user.id} AND order_type_id=4", :include => :user).order('created_at DESC').page(params[:scan_orders_page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @orders }
    end
  end

  def new #create empty order and redirect to edit it
    @order = Order.new(:order_type_id => Lists::OrderType.where(:title => params[:order_type]).first.id)
    @order.set_status(10)
    set_price(@order)
    current_user.orders << @order
    respond_to do |wants|
        if @order.save(:validate => false)
          wants.html {redirect_to edit_order_path(@order)}
          wants.xml {render :xml => @order.to_xml}
        end
      end
  end
  
  def edit
    @title = "Заказ №#{@order.id}"
    #проверка возможности редактировать заказ
    if @order.read_status_key == 10
      user_can_edit = true
      gon.delivery_dates = current_user.get_delivery_dates(@order)
    else
      user_can_edit = false
    end

    #рендер view в зависимости от типа заказа
    respond_to do |format|
      case @order.order_type.title
      when 'foto_print'
        if user_can_edit == true
          format.html { render 'orders/foto_print/new_foto_print' } 
        else
          flash[:error] = 'Вы не можете редактировать созданный ранее заказ.'
          format.html { redirect_to my_orders_path}
        end
      when 'doc_print'
        if user_can_edit == true
          format.html { render 'orders/doc_print/new_doc_print' } 
        else
          flash[:error] = 'Вы не можете редактировать созданный ранее заказ.'
          format.html { redirect_to my_orders_path}
        end
      when 'scan'
        if user_can_edit == true
          format.html { render 'orders/scan/new_scan'}
        else
          flash[:error] = 'Вы не можете редактировать созданный ранее заказ.'
          format.html { redirect_to my_orders_path}      
        end
      end 
    end
  end
  
  def edit_files
    @title = "Обновление заказа №#{@order.id}"
    #рендер view в зависимости от типа заказа
    respond_to do |format|
      case @order.order_type.title
      when 'foto_print'
        format.html { render 'orders/foto_print/admin_edit_files' }
      when 'doc_print'
        format.html { render 'orders/doc_print/admin_edit_files' }
      when 'scan'
        format.html { render 'orders/scan/admin_edit_files'}
      end 
    end
  end
  
  def edit_delivery
    @title = "Обновление заказа №#{@order.id}"
    gon.delivery_dates = @order.user.get_delivery_dates(@order) #get dates of delivery for user order
    #рендер view в зависимости от типа заказа
    respond_to do |format|
      case @order.order_type.title
      when 'foto_print'
        @order_class = 'admin_foto_print_order'
        format.html { render 'orders/share/admin_edit_delivery' }
      when 'doc_print'
        @order_class = "admin_doc_print_order"
        format.html { render 'orders/share/admin_edit_delivery' }
      when 'scan'
        format.html { render 'orders/scan/admin_edit_delivery'}
      end 
    end
  end

  def edit_status
    @title = "Обновление заказа №#{@order.id}"
    #рендер view в зависимости от типа заказа
    respond_to do |format|
      case @order.order_type.title
      when 'foto_print'
        @order_class = 'admin_foto_print_order'
        format.html { render 'orders/share/admin_edit_status' }
      when 'doc_print'
        @order_class = "admin_doc_print_order"
        format.html { render 'orders/share/admin_edit_status' }
      when 'scan'
        format.html { render 'orders/scan/admin_edit_status'}
      end 
    end
  end

  def update
    @order = Order.find(params[:id])
    if current_user.has_role?('Administrator')  # если администратор или менеджер
      old_status_key = @order.order_status.key
      new_status_key = params[:order][:order_status_id].nil? ? old_status_key : get_status_key_from_id(params[:order][:order_status_id])
      respond_to do |wants|
        if attr_update(@order, new_status_key) 
            if new_status_key != old_status_key #отправка сообщения на почту пользователя, ели статус был изменен
              if new_status_key == 50
                UserMailer.email_user_about_complete_order(@order).deliver
              elsif new_status_key == 10
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
    else #если обычный пользователь
        if attr_update(@order, 20)
          @order.update_attribute(:created_at, Time.now)
          UserMailer.email_all_admins_about_new_order(@order)
          UserMailer.email_user_about_new_order(@order).deliver
          flash[:notice] = 'Спасибо! Заказ создан. В ближайшее время мы свяжемся с вами.'
          redirect_to my_orders_path
        end
    end
  end

  def attr_update(order, status_key) #update main user attributes of order
    case order.order_type.title
    when 'foto_print', 'doc_print'
      if (order.documents.length == 0)
        flash[:error] = 'Для оформления заказа необходимо загрузить хотя бы один файл.'
        redirect_to :action => "edit"
        return false
      else
        order.documents.each do |document|
          unless params[:order][:documents_attributes].nil?
            document.update_attribute(
                    :user_comment, params[:order][:documents_attributes][document.id.to_s][:user_comment],
                    )
          end
        end
      end
    when 'scan'
      order.scan.update_attributes(params[:order][:scan_attributes])
    end
    
    if (params[:order][:delivery_town_id] == "" || params[:order][:delivery_address] == "" || params[:order][:delivery_date] == "")  
        flash[:error] = 'Для оформления заказа необходимо заполнить информацию о доставке.'
        redirect_to :action => "edit"
        return false
    elsif params[:order][:delivery_town_id] && params[:order][:delivery_address] && params[:order][:delivery_date]
        order.update_attributes(
            :delivery_town_id => params[:order][:delivery_town_id], 
            :delivery_street => params[:order][:delivery_street], 
            :delivery_address => params[:order][:delivery_address], 
            :delivery_date => params[:order][:delivery_date])
    end
    if params[:order][:delivery_start_time] == ""
       params[:order][:delivery_start_time] = Order::DEFAULT_START_TIME
    end
    if params[:order][:delivery_end_time] == ""
       params[:order][:delivery_end_time] = Order::DEFAULT_END_TIME
    end
    if params[:order][:cost]
       order.update_attribute(:cost, params[:order][:cost])
    end
    if params[:order][:delivery_start_time] && params[:order][:delivery_end_time]
       order.update_attributes(
            :delivery_start_time => params[:order][:delivery_start_time], 
            :delivery_end_time => params[:order][:delivery_end_time])
    end
    if params[:order][:manager_comment]
       order.update_attribute(:manager_comment, params[:order][:manager_comment])
    end
    
    order.update_attribute(:order_status_id, get_status_id_from_key(status_key))
    return true
  end

  def show
    @title = "Заказ № #{@order.id}"
    respond_to do |format|
      case @order.order_type.title
      when 'foto_print'
         format.html { render 'orders/foto_print/show_foto_print_order' }
      when 'doc_print'
         format.html { render 'orders/doc_print/show_doc_print_order' }
      when 'scan'
         format.html { render 'orders/scan/show_scan_order' } 
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

  def ajaxupdate
    if params[:delivery_type]
      @order.update_attribute(:delivery_type, params[:delivery_type])
    end
    if params[:delivery_date]
      @order.update_attribute(:delivery_date, params[:delivery_date])
    end
    if params[:delivery_town]
      @order.update_attribute(:delivery_town_id, params[:delivery_town].to_i)
    end
    set_price(@order)
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
  
  def get_materials
     @order = Order.find_by_id(params[:id])
     @title = "Использование материалов в заказе №#{@order.id}"
     @lines = Hash.new
     Lists::PaperSpecification.all.each do |pspec|
       @documents_quantity = 0
       @order.documents.each do |document|
         if pspec == document.paper_specification
           @documents_quantity = @documents_quantity + document.page_count.to_i*document.quantity.to_i
         end
         unless @documents_quantity == 0
           @lines.merge!(pspec.full_paper_format => @documents_quantity)
         end
       end 
     end
     render layout: "cover_for_order"
  end

  private
    def set_price(order)
      #cчитаем доставку
      if order.delivery_type == 'Курьер'
        #ищем цену доставки в прайсе и проверяем есть ли уже заказы на дату
        if order.user.get_delivery_dates(order).include?(order.delivery_date)
          delivery_price = 0
        else
          delivery_price = order.delivery_town.delivery_zone.price
        end
      else
        delivery_price = 0
      end
      order.update_attribute(:delivery_price, delivery_price)

      documents_cost = 0
      order_cost_min = 0
      order_cost_max = 0
      order_cost = 0
      
      case order.order_type.title
      when 'foto_print', 'doc_print'  #считаем документы, если они есть
        if order.documents.size > 0
          order.documents.each do |document|
            (documents_cost = documents_cost + document.cost) unless document.cost.nil?
          end
        end
        order_cost = order.delivery_price + documents_cost
        order_cost_min = order_cost
        order_cost_max = order_cost
      when 'scan' #считаем сканы, если они есть
        if order.scan
          order_cost_min = order.scan.cost_min + order.delivery_price
          order_cost_max = order.scan.cost_max + order.delivery_price
          if order_cost_min == order_cost_max && order_cost_min != 0
            order_cost = order_cost_min
          end
        end
      end
     order.update_attribute(:cost, order_cost) 
     order.update_attribute(:cost_min, order_cost_min) 
     order.update_attribute(:cost_max, order_cost_max) 
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

