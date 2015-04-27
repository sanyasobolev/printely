# encoding: utf-8
class OrderStepsController < ApplicationController
  include Wicked::Wizard

  skip_before_filter :authorized?,
                     :only => [:index, :show, :update]

  skip_before_filter :verify_authenticity_token,
                     :only => [:show, :update]

  before_filter :can_you_edit_order?,
                :only => [:show, :update]

  steps :documents, :delivery, :confirm

  def show
    @title = "Заказ №#{@order.id}"
    @form_header_class = 'light_blue'
    case step
    when :documents
      case @order.order_type.title
      when 'foto_print'
        @js_libraries = [
              "orders/uploadfn",
              "orders/foto_print_order_documents"
              ]  
        @upload_button = 'icons/plus_double_large.png'
        @form_header = 'Загрузите Ваши файлы'
        @partial = 'orders/foto_print/filelist'
      when 'doc_print'
        @js_libraries = [
              "orders/uploadfn",
              "orders/doc_print_order_documents"
              ]  
        @upload_button = 'icons/plus_double_large.png'
        @form_header = 'Загрузите Ваши файлы'
        @partial = 'orders/doc_print/filelist'
      when 'envelope_print'
        @js_libraries = [
              "orders/uploadfn",
              "orders/editorfn",
              "orders/envelope_print_order_documents",
              "fabric/canvasfn",
              "fabric/fabric_ext"
              ]
        @upload_button = 'icons/plus_grey.png'
        @form_header = 'Разработайте макет'
        @partial = 'documents/envelope_print/document'
            
        @document = @order.documents.empty? ? @order.documents.create : @order.documents.first
        @document.docfile = Rails.root.join("public/fallback/default.png").open
        @document.save! 
      end 
    when :delivery
        @js_libraries = [
              "orders/uploadfn",
              "orders/deliveryfn",
              "orders/calendarfn",
              "orders/order_delivery",
              ]
        @form_header_class = 'light_green'
        @form_header = 'Укажите адрес и время доставки'
        gon.delivery_dates = current_user.get_delivery_dates(@order)
    when :confirm
        @js_libraries = [
              "orders/order_confirm",
              ]
        @title = "Подтвердите Ваш заказ №#{@order.id}"
        @documents_specification_lines = @order.get_document_specification
        @order_description = @order.order_type.description
        @delivery_type = @order.delivery_type
    end
    render_wizard
  end

  def update
    case step
    when :documents
      #обновляем атрибуты заказа
      @order.documents.each do |document|
        unless params[:order][:documents_attributes].nil?
          document.update_attribute(
              :user_comment, params[:order][:documents_attributes][document.id.to_s][:user_comment],
          )
        end
      end
    when :delivery
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
    when :confirm
      @order.update_attribute(:order_status_id, get_status_id_from_key(20))
      #рассылаем письма
      UserMailer.email_all_admins_about_new_order(@order)
      UserMailer.email_user_about_new_order(@order).deliver
      #обновляем дату создания
      @order.update_attribute(:created_at, Time.now)
    end 
    render_wizard @order #save order attributes
  end

 private
    
    def get_status_id_from_key(key)
      Lists::OrderStatus.where(:key => key).first.id
    end

    def finish_wizard_path
      flash[:notice] = 'Отлично! Ваш заказ создан. Ожидайте подтверждение по телефону или SMS.' 
      session[:order_id] = nil      
      my_orders_path
    end

end
