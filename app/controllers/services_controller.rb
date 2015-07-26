# encoding: utf-8
class ServicesController < ApplicationController
  layout 'services', :only => [:index]
  skip_before_filter :login_required, :authorized?,
                     :only => [:index]
  
  def index
    @title = Section.find_by_controller(controller_name).title
    @services = Service.all
    @page_about_services = Page.find_by_id('2', :conditions => "published=true")
  end


end
