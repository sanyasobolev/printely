class SectionsController < ApplicationController
  
  before_filter :find_section
  
  def show
    load_content
  end
  
  
  private
  
  def find_section
    if @section = Section.find_by(permalink: params[:id])
      @title = @section.title
    else
      render_error(404) #not_found
    end
  end
  
  
  def load_content
    if have_page?
      render "pages/show"
    elsif have_another_action?
      redirect_to controller: @section.controller, action: @section.action
    else
      render_error(204) #no_content
    end
  end
  
  def have_page?
    if @section.page
      @page = @section.page.published ? @section.page : nil
    else
      nil
    end
  end
 
  def have_another_action?
    !(@section.controller.blank? && @section.action.blank?)
  end
  
end
