class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  include AuthenticatedSystem #методы чтения и изменения атрибута current_user
  before_filter :login_from_cookie #проверяем наличие куки и аутентифицируем пользователя
  before_filter :login_required
  before_filter :authorized?
  before_filter :set_locale
  
  I18n.config.enforce_available_locales = true
  #The possible values are:
  #false: if you
    #want to skip the locale validation
    #don't care about locales
  #true: if you
    #want the application to raise an error if an invalid locale is passed (or)
    #want to default to the new Rails behaviors (or)
    #care about locale validation
  
  #set locale from domain
  def set_locale 
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

  unless Rails.application.config.consider_all_requests_local
    #rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end
 
  private
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
  
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

end
