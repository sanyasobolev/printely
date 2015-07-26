# encoding: utf-8
class OrdersController < ApplicationController
  layout 'order', :only => [:index, :my, :show]
  
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

 def set_delivery_price
    @order.update_attribute(:delivery_type, params[:delivery_type]) if params[:delivery_type]
    @order.update_attribute(:delivery_date, params[:delivery_date]) if params[:delivery_date]
    @order.update_attribute(:delivery_town_id, params[:delivery_town]) if params[:delivery_town]

    update_delivery_price(@order)
    respond_to do |format|
        format.js { render 'orders/delivery/price'}
    end
 end

 def set_documents_price
    update_documents_price(@order)
    respond_to do |format|
        format.js { render 'orders/share/documents_price'}
    end
 end

  private
  
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

