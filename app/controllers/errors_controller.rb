class ErrorsController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:error_404, :error_500]
                     
  def error_404
    @not_found_path = params[:not_found]
  end
 
  def error_500
  end
end
