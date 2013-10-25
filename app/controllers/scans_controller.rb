# encoding: utf-8
class ScansController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:create, :destroy, :ajaxupdate]

#  skip_before_filter :verify_authenticity_token,
#                    :only => [:create]  

  before_filter :find_order,
                :only => [:create, :ajaxupdate]
                
  before_filter :find_or_build_scan,
                :only => [:create, :ajaxupdate]

  
  def create
    #set_defaults_params
    set_price(@scan.scan_documents_quantity, @scan.base_correction_documents_quantity, @scan.coloring_documents_quantity, @scan.restoration_documents_quantity)
    #---------------------
      unless @scan.save
        flash[:error] = 'Ошибка при сохранении данных'
      else
       respond_to do |format|
            if @scan.cost_min == @scan.cost_max
               format.js { render :single_cost }
            else
               format.js { render :min_max_cost } 
            end
          end
      end
  end
  
  def ajaxupdate
    if params[:selected_scan_documents_quantity]
      @scan.update_attribute(:scan_documents_quantity, params[:selected_scan_documents_quantity])
    elsif params[:selected_base_correction_documents_quantity]
      @scan.update_attribute(:base_correction_documents_quantity, params[:selected_base_correction_documents_quantity])
    elsif params[:selected_coloring_documents_quantity]
      @scan.update_attribute(:coloring_documents_quantity, params[:selected_coloring_documents_quantity])
    elsif params[:selected_restoration_documents_quantity]
      @scan.update_attribute(:restoration_documents_quantity, params[:selected_restoration_documents_quantity])
    end
    
    set_price(@scan.scan_documents_quantity, @scan.base_correction_documents_quantity, @scan.coloring_documents_quantity, @scan.restoration_documents_quantity)
    @scan.update_attributes(:cost_min => @scan.cost_min, :cost_max => @scan.cost_max)
     respond_to do |format|
          if @scan.cost_min == @scan.cost_max
             format.js { render :single_cost }
          else
             format.js { render :min_max_cost } 
          end
        end
  end  
  
  private
 
    def find_order
      @order = Order.find_by_id(params[:order_id])
      raise ActiveRecord::RecordNotFound unless @order
    end
  
    def find_or_build_scan
      @scan = @order.scan ? @order.scan : @order.build_scan
    end
    
    def set_price(scan_documents_quantity, base_correction_documents_quantity, coloring_documents_quantity, restoration_documents_quantity)
      @scan.cost_min = (PricelistScan.where(:work_name => 'scan').first.price_min)*scan_documents_quantity + (PricelistScan.where(:work_name => 'base_correction').first.price_min)*base_correction_documents_quantity + (PricelistScan.where(:work_name => 'coloring').first.price_min)*coloring_documents_quantity + (PricelistScan.where(:work_name => 'restoration').first.price_min)*restoration_documents_quantity
      @scan.cost_max = (PricelistScan.where(:work_name => 'scan').first.price_max)*scan_documents_quantity + (PricelistScan.where(:work_name => 'base_correction').first.price_max)*base_correction_documents_quantity + (PricelistScan.where(:work_name => 'coloring').first.price_max)*coloring_documents_quantity + (PricelistScan.where(:work_name => 'restoration').first.price_max)*restoration_documents_quantity
    end
  
end
