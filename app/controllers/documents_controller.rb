# encoding: utf-8
class DocumentsController < ApplicationController

  skip_before_filter :authorized?,
                     :only => [
                       :create, 
                       :destroy, 
                       :update, 
                       :get_paper_sizes, 
                       :get_paper_types, 
                       :get_print_margins, 
                       :get_print_colors
                       ]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]

  before_filter :find_order,
                :only => [
                  :create, 
                  :destroy, 
                  :get_paper_sizes, 
                  :get_paper_types, 
                  :get_print_margins, 
                  :get_print_colors]
  
  before_filter :find_or_build_document,
                :only => [
                  :create, 
                  :destroy, 
                  :get_paper_sizes, 
                  :get_paper_types, 
                  :get_print_margins, 
                  :get_print_colors
                  ]


  def create
    case @order.order_type.title
    when 'foto_print', 'doc_print'
        @document.docfile = params[:document][:docfile]
        respond_to do |format|  
          unless @document.save
            flash[:error] = 'File could not be uploaded'
          else
            format.js do
              render :text => render_to_string(:partial => "documents/#{@order.order_type.title}/document", :locals => {:document => @document})
            end
          end
        end   
    when 'envelope_print'
       #save svg data to file
       @document.docfile = params[:svg_file] if params[:svg_file]

       #save image data to file
       @document.docfile = params[:image] if params[:image]
            
       respond_to do |format|  
           unless @document.save
             flash[:error] = 'File could not be uploaded'
           else
             format.js do
               render :text => 'file created', :status => 200, :content_type => 'text/html'
             end
           end
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

  def update
    @document = Document.find_by_id(params[:id])
    
    case params[:order_type]
      when 'foto_print'
        if params[:margins] #на случай если придет только quantity
          @document.paper_specification = Lists::PaperSpecification.find_paper_specification(params[:paper_size], params[:paper_type])
          @document.print_margin = Lists::PrintMargin.find_by_id(params[:margins])     
        end
      when 'doc_print'
        if params[:print_color]#на случай если придет только quantity
          @document.paper_specification = Lists::PaperSpecification.find_paper_specification(params[:paper_size], params[:paper_type])
          @document.print_color = Lists::PrintColor.find_by_id(params[:print_color])
          @document.binding = Lists::Binding.find_by_id(params[:binding])
        end
      when 'envelope_print'
        if params[:paper_type]#на случай если придет только quantity
          @document.paper_specification = Lists::PaperSpecification.find_paper_specification(params[:paper_size], params[:paper_type])
        end    
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
    
    @document.calculate_cost
    @document.change_file_name
    
    respond_to do |format|
      format.js
    end
  end

  def get_paper_sizes
    @available_paper_sizes = Lists::PaperSize.available_paper_sizes(params[:order_type])

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
  @available_paper_types = Lists::PaperType.available_paper_types(
                                            params[:order_type], 
                                            params[:selected_paper_size]
                                            )
  @available_paper_grades = Lists::PaperGrade.paper_grades_by_paper_types(
                                            @available_paper_types
                                            )
  
  
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
  
  def get_print_colors
    @available_print_colors = Lists::PrintColor.available_print_colors(params[:order_type])
    
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

  def get_print_margins
    @available_margins = Lists::PrintMargin.available_print_margins(params[:order_type])    
    
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


  private
    def find_order
      @order = Order.find_by_id(params[:order_id])
      raise ActiveRecord::RecordNotFound unless @order
    end

    def find_or_build_document
      @document = params[:id] ? @order.documents.find(params[:id]) : @order.documents.build(@order.order_type)
    end

end
