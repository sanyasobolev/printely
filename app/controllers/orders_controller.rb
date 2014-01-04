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
    
    @draft_orders = Order.where(:order_status_id => get_status_id_from_key(10), :user_id => current_user.id)
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
    @order = Order.new(:order_type => 'print')
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
  
  def new_scan 
    @order = Order.new(:order_type => 'scan')
    @order.set_status(10)
    set_price(@order)
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
    if @order.read_status_key == 10 || @admin_edit == true
      user_can_edit = true
    else
      user_can_edit = false
    end

    #рендер view в зависимости от типа заказа
    respond_to do |format|
      case @order.order_type
      when 'print'
        if @admin_edit == true
          format.html { render :admin_edit_print }
        elsif user_can_edit == true
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
      old_status_key = @order.order_status.key
      new_status_key = get_status_key_from_id(params[:order][:order_status_id])
      if attr_update(@order, new_status_key) 
        respond_to do |wants|
          if @order.update_attributes(:manager_comment => params[:order][:manager_comment])
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
      end
    else #если обычный пользователь
        if attr_update(@order, 20)
          UserMailer.email_all_admins_about_new_order(@order)
          UserMailer.email_user_about_new_order(@order).deliver
          flash[:notice] = 'Спасибо! Заказ создан. В ближайшее время мы свяжемся с вами.'
          redirect_to my_orders_path
        end
    end
  end

  def attr_update(order, status_key) #update main user attributes of order
    case order.order_type
    when 'print'
      if (order.documents.length == 0)
        flash[:error] = 'Для оформления заказа необходимо загрузить хотя бы один файл.'
        redirect_to :action => "edit"
        return false
      else
        order.documents.each do |document|
          unless params[:order][:documents_attributes].nil?
            @dspec_id = Lists::DocumentSpecification.joins(paper_specification: :paper_type).where("lists_paper_types.paper_type = '#{params[:order][:documents_attributes][document.id.to_s][:paper_type]}'").joins(paper_specification: :paper_size).where("lists_paper_sizes.size = '#{params[:order][:documents_attributes][document.id.to_s][:paper_size]}'").joins(:print_margin).where("lists_print_margins.margin = '#{params[:order][:documents_attributes][document.id.to_s][:margins]}'").first.id
            document.update_attributes(
                    :quantity => params[:order][:documents_attributes][document.id.to_s][:quantity],
                    :user_comment => params[:order][:documents_attributes][document.id.to_s][:user_comment],
                    :document_specification_id => @dspec_id
                    )
          end
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
            :order_status_id => get_status_id_from_key(status_key), 
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

  def admin
    @title = "Управление заказами"
    if params[:q]
      @search = Order.search(params[:q]) 
    else
      @search = Order.search(:order_status_key_not_eq => 10) 
    end
    @search.sorts = 'id desc' if @search.sorts.empty?
    @orders = @search.result 
    @search.build_condition
  end

  def ajaxupdate
    if params[:delivery_type]
      @order.update_attribute(:delivery_type, params[:delivery_type])
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
         if pspec == document.get_paper_specification
           @documents_quantity = @documents_quantity + document.quantity.to_i
         end
         unless @documents_quantity == 0
           @lines.merge!(pspec.full_paper_format_wo_stock => @documents_quantity)
         end
       end 
     end
     render layout: "cover_for_order"
  end

  private
    def set_price(order)
      #cчитаем доставку
      if order.delivery_type
        #ищем цену доставки в прайсе
        delivery_price = PricelistDelivery.where(:delivery_type => order.delivery_type).first.price
      else
        delivery_price = 0
      end
      order.update_attribute(:delivery_price, delivery_price)

      documents_cost = 0
      order_cost_min = 0
      order_cost_max = 0
      order_cost = 0
      
      case order.order_type
      when 'print' #считаем документы, если они есть
        if order.documents.size > 0
          order.documents.each do |document|
            documents_cost = documents_cost + document.price
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

