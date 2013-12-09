# encoding: utf-8
class DocumentsController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:create, :destroy, :price_update, :get_paper_sizes, :get_paper_types, :get_print_margins]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]


  before_filter :find_order,
                :only => [:create, :destroy]
  before_filter :find_or_build_document,
                :only => [:create, :destroy]

  def create
    #set_defaults_params
    @document.quantity = '1'
    @document.user_filename = params[:Filename] #save user file name
    @document.docfile = params[:file]
    respond_to do |format|
      unless @document.save
        flash[:error] = 'Photo could not be uploaded'
      end
      format.js do
        render :text => render_to_string(:partial => 'documents/document', :locals => {:document => @document})
      end
    end
  end

  def price_update
    @document = Document.find_by_id(params[:id])
    if params[:paper_size] && params[:paper_type] && params[:margins] 
      @dspec = Lists::DocumentSpecification.joins(paper_specification: :paper_type).where("lists_paper_types.paper_type = '#{params[:paper_type]}'").joins(paper_specification: :paper_size).where("lists_paper_sizes.size = '#{params[:paper_size]}'").joins(:print_margin).where("lists_print_margins.margin = '#{params[:margins]}'").first
      @document.document_specification = @dspec
      @document.save
    end
    if params[:quantity]
      @document.update_attribute(:quantity, params[:quantity])
    end
    set_price(@document.document_specification, @document.quantity)
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
          if paper_specification.in_stock == true #if paper in stock
            @dspecs = Lists::DocumentSpecification.joins(:paper_specification => :paper_size).where("lists_paper_sizes.size = '#{paper_size.size}'")
            @dspecs.each do |dspec|
              if dspec.available == true
                @available_paper_sizes << paper_size
                break
              end
            end         
          end
        end
      end
    end
    @available_paper_sizes = @available_paper_sizes.uniq.sort_by{|e| e[:size]}
    respond_to do |format|
        format.html do
          render :partial => 'available_paper_size' , :collection => @available_paper_sizes
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
        if paper_specification.in_stock == true && paper_specification.paper_size.size == params[:selected_paper_size] #if paper in stock and have selected size
          @dspecs = Lists::DocumentSpecification.joins(:paper_specification => :paper_type).where("lists_paper_types.paper_type = '#{paper_type.paper_type}'").joins(:paper_specification => :paper_size).where("lists_paper_sizes.size = '#{params[:selected_paper_size]}'")
          @dspecs.each do |dspec|
            if dspec.available == true
              @available_paper_types << paper_type
              break
            end
          end         
        end
      end
    end
  end
  @available_paper_types = @available_paper_types.uniq
  
  @available_paper_types.each do |paper_type|
    @available_paper_grades << paper_type.paper_grade
  end
  @available_paper_grades = @available_paper_grades.uniq
  
  @select_list = ""
  for available_paper_grade in @available_paper_grades
    @select_list = @select_list + "<optgroup label= #{available_paper_grade.grade}>"
      for available_paper_type in @available_paper_types
        if available_paper_type.paper_grade.grade == available_paper_grade.grade
          @select_list = @select_list + "<option value=#{available_paper_type.paper_type}>#{available_paper_type.paper_type}</option>"
        end
      end
      @select_list = @select_list + "</optgroup>"
  end
   
  respond_to do |format|
      format.html do
        render :partial=> 'available_paper_types'
      end
    end
  end
  
  def get_print_margins
    @available_documents = Lists::DocumentSpecification.joins(:paper_specification => :paper_size).where("lists_paper_sizes.size = '#{params[:selected_paper_size]}'").joins(:paper_specification => :paper_type).where("lists_paper_types.paper_type = '#{params[:selected_paper_type]}'")
    @available_margins= Array.new
    @available_documents.each do |available_document|
      @available_margins << available_document.print_margin
    end
    @available_margins = @available_margins.uniq.sort_by{|e| e[:margin]}
    respond_to do |format|
        format.html do
          render :partial => 'available_margin' , :collection => @available_margins
        end
    end
  end

  def destroy
    respond_to do |format|
      unless @document.destroy
        flash[:error] = 'Документ не может быть удален.'
      end
        format.js
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

    def set_price(document_specification, quantity)
      @document.price = document_specification.price*quantity
      @document.update_attribute(:price, @document.price)
    end
    
    def change_file_name
      @document.docfile.recreate_versions!
      @document.save!      
    end
end
