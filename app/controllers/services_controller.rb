# encoding: utf-8
class ServicesController < ApplicationController
  layout 'services', :only => [:index]
  
  def index
    @title = Section.find_by(controller: controller_name).title
    @services = Service.all
    @page_about_services = Page.find(2)
  end


end
