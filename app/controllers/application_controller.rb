class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  include AuthenticatedSystem #методы чтения и изменения атрибута current_user
  before_filter :login_from_cookie #проверяем наличие куки и аутентифицируем пользователя
  before_filter :login_required
  before_filter :authorized?

  def current_section_title
    if params[:section_id]
      @current_section_title = Section.find_by_permalink(params[:section_id]).title
    else
      @current_section_title = Section.find_by_controller(controller_name).title
    end
    return @current_section_title
  end

end
