# encoding: utf-8
class DocumentsController < ApplicationController

  skip_before_filter :authorized?,
                     :only => [:create, :destroy, :price_update, :get_paper_sizes, :get_paper_types, :get_print_margins, :get_print_colors, :get_layout]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]

  before_filter :find_order,
                :only => [:create, :destroy, :get_paper_sizes, :get_paper_types, :get_print_margins, :get_print_colors]
  before_filter :find_or_build_document,
                :only => [:create, :destroy, :get_paper_sizes, :get_paper_types, :get_print_margins, :get_print_colors]

  def create
    #set_defaults_params
    @document.user_filename = params[:Filename] #save user file name
    @document.docfile = params[:file]
    respond_to do |format|
      unless @document.save
        flash[:error] = 'File could not be uploaded'
      else
        format.js do
          if @order.order_type.title == 'foto_print'
            render :text => render_to_string(:partial => 'documents/foto_print/document', :locals => {:document => @document})
          elsif @order.order_type.title == 'doc_print'
            render :text => render_to_string(:partial => 'documents/doc_print/document', :locals => {:document => @document})
          end
        end
      end
    end
  end

  def price_update
    @document = Document.find_by_id(params[:id])
    if params[:order_type] == 'foto_print' #for foto_print_order
      @document.paper_specification = Lists::PaperSpecification.where(:paper_type_id => params[:paper_type]).where(:paper_size_id => params[:paper_size]).first
      @document.print_margin = Lists::PrintMargin.find_by_id(params[:margins])
      @document.save
    elsif params[:order_type] == 'doc_print' #for doc_print_order
      @document.paper_specification = Lists::PaperSpecification.where(:paper_type_id => params[:paper_type]).where(:paper_size_id => params[:paper_size]).first
      @document.print_color = Lists::PrintColor.find_by_id(params[:print_color])
      @document.binding = Lists::Binding.find_by_id(params[:binding])
      @document.save
    end
    if params[:quantity]
      @document.update_attribute(:quantity, params[:quantity])
    end
    if params[:pre_print_operation]
      pre_print_operation = Lists::PrePrintOperation.find_by_id(params[:pre_print_operation].to_i)
      if params[:check_status].to_i == 1
        @document.pre_print_operations << pre_print_operation
      else
        @document.pre_print_operations.delete(pre_print_operation)
      end
      @document.save
    end
    if params[:page_count]
      @document.update_attribute(:page_count, params[:page_count])
    end
    set_price(@document)
    change_file_name
    respond_to do |format|
        format.js
      end
  end

  def get_paper_sizes
    @all_paper_sizes = Lists::PaperSize.all
    @available_paper_sizes = Array.new
    
    @all_paper_sizes.each do |paper_size|
      if paper_size.paper_specifications.size > 0 #if have paper_specifications
        paper_size.paper_specifications.each do |paper_specification|
          if paper_specification.in_stock == true && (paper_specification.order_type.title == params[:order_type] || paper_specification.order_type.title == 'all') #if paper in stock
            @available_paper_sizes << paper_size
            break
          end
        end
      end
    end

    @select_list = ''
    for available_paper_size in @available_paper_sizes
      value = available_paper_size.id
      if @document.get_paper_size && @document.get_paper_size.id == value
        selected = "selected='selected'"
      else
        selected = ""
      end
      unless available_paper_size.size_iso_216.blank?
         select = "#{available_paper_size.size} | #{available_paper_size.size_iso_216}"
      else
         select = "#{available_paper_size.size}"
      end 
      option_end = "</option>"
      
      @select_list = @select_list + "<option value='#{value}' "+"#{selected}"+">"+"#{select}"+"#{option_end}"
    end
    
    respond_to do |format|
        format.html do
          render :partial => 'select_list' 
        end
    end
  end

  def get_paper_types
  @all_paper_types = Lists::PaperType.all
  @all_paper_grades = Lists::PaperGrade.all
  @available_paper_types = Array.new
  @available_paper_grades = Array.new
    
  @all_paper_types.each do |paper_type|
    if paper_type.paper_specifications.size > 0 #if have paper_specifications
      paper_type.paper_specifications.each do |paper_specification|
        if paper_specification.in_stock == true && paper_specification.paper_size_id == params[:selected_paper_size].to_i && (paper_specification.order_type.title == params[:order_type] || paper_specification.order_type.title == 'all') #if paper in stock, have selected size and have order type
           @available_paper_types << paper_type
           break
        end
      end
    end
  end
  
  @available_paper_types.each do |paper_type|
    @available_paper_grades << paper_type.paper_grade
  end
  @available_paper_grades = @available_paper_grades.uniq
  
  @select_list = ""
  for available_paper_grade in @available_paper_grades
    @select_list = @select_list + "<optgroup label= #{available_paper_grade.grade}>"
      for available_paper_type in @available_paper_types
        if available_paper_type.paper_grade.id == available_paper_grade.id
            value = available_paper_type.id
            if @document.get_paper_type && @document.get_paper_type.id == value
              selected = "selected='selected'"
            else
              selected = ""
            end
            if params[:with_density]
              select = "#{available_paper_type.paper_type}, #{available_paper_type.paper_density.density} г/м2"
            else
              select = "#{available_paper_type.paper_type}"
            end
            option_end = "</option>"
            
            @select_list = @select_list + "<option value='#{value}' "+"#{selected}"+">"+"#{select}"+"#{option_end}"
        end
      end
      @select_list = @select_list + "</optgroup>"
  end
   
  respond_to do |format|
      format.html do
        render :partial => 'select_list' 
      end
    end
  end
  
  def get_print_margins
    @available_margins = Lists::PrintMargin.where(["order_type_id = ? or order_type_id = ?", Lists::OrderType.where(:title => params[:order_type]), 1]) #order_type or all order types
    @select_list = ''
    for available_margin in @available_margins
      value = available_margin.id
      if @document.print_margin && @document.print_margin.id == value
        selected = "selected='selected'"
      else
        selected = ""
      end
      select = "#{available_margin.margin}"
      option_end = "</option>"
      
      @select_list = @select_list + "<option value='#{value}' "+"#{selected}"+">"+"#{select}"+"#{option_end}"
    end
    
    respond_to do |format|
        format.html do
          render :partial => 'select_list' 
        end
    end
  end
    
  
  def get_layout
    @pspec = Lists::PaperSpecification.where(["paper_type_id = ? and paper_size_id = ?", params[:selected_paper_type].to_i, params[:selected_paper_size].to_i]).first
    @item = ''

    if !@pspec.layout?
      @item = "Нет изображения макета."
    else
      @item = "<img src='"+"#{@pspec.layout_url}"+"'>"
    end
    
    respond_to do |format|
        format.html do
          render :partial => 'item' 
        end
    end
  end

  def get_print_colors
    @available_print_colors = Lists::PrintColor.where(["order_type_id = ? or order_type_id = ?", Lists::OrderType.where(:title => params[:order_type]), 1])#order_type or all order types
    
    @select_list = ''
    for available_print_color in @available_print_colors
      value = available_print_color.id
      if @document.print_color && @document.print_color.id == value
        selected = "selected='selected'"
      else
        selected = ""
      end
      select = "#{available_print_color.color}"
      option_end = "</option>"
      
      @select_list = @select_list + "<option value='#{value}' "+"#{selected}"+">"+"#{select}"+"#{option_end}"
    end
    
    respond_to do |format|
        format.html do
          render :partial => 'select_list' 
        end
    end
  end


  def destroy
    respond_to do |format|
      unless @document.destroy
        flash[:error] = 'Документ не может быть удален.'
      end
        format.js { render :template => 'documents/destroy.js.erb', :layout => false }
    end
  end

  private
    def find_order
      @order = Order.find_by_id(params[:order_id])
      raise ActiveRecord::RecordNotFound unless @order
    end

    def find_or_build_document
      @document = params[:id] ? @order.documents.find(params[:id]) : @order.documents.build(params[:document])
    end

    def set_price(document)
      margin_price = document.print_margin.nil? ? 0 : document.print_margin.price
      print_color_price = document.print_color.nil? ? 0 : document.print_color.price
      binding_price = document.binding.nil? ? 0 : document.binding.price

      pre_print_operations_price = 0
      if document.pre_print_operations.size > 0 
        document.pre_print_operations.each do |pre_print_operation|
          pre_print_operations_price = pre_print_operations_price + pre_print_operation.price
        end
      end
      
      document.price = (document.paper_specification.price + margin_price + print_color_price)*document.page_count + binding_price + pre_print_operations_price
      document.cost = (document.price - pre_print_operations_price)*document.quantity + pre_print_operations_price
      document.save
    end
    
    def change_file_name
      @document.docfile.recreate_versions!
      @document.save!      
    end
end
