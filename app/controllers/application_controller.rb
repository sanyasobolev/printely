class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  protect_from_forgery with: :exception
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include TheRole::Controller #методы авторизации гема TheRole

  before_action :set_locale  #set locale from domain
  
  #rescue_from ActiveRecord::RecordNotFound, with: :not_found

  
  def set_locale 
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

  def not_found
    render_error(404)
  end
 
  private
  def render_error(status)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application'}
      format.all { render nothing: true, status: status }
    end
  end
  
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

end
