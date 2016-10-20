# encoding: utf-8
class SessionsController < ApplicationController

  layout 'login'

  def new
    @title = 'Вход в систему'
  end

  def create # вход в систему
  	current_user = User.authenticate(params[:user][:email], params[:user][:password])
    if logged_in?
      if current_user.admin? || current_user.has_role?(:settings, :index)
        redirect_to admin_settings_path
      else
        redirect_to myoffice_path
      end
    else
      flash[:error] = "Вы ввели неверный логин или пароль!"
      redirect_to :action => :new
    end
  end

  def destroy #выход из системы
    self.current_user.forget_me if logged_in? #очитска информации о запоминании пользователя
    cookies.delete :auth_token
    session[:user_id] = nil
    #reset_session
    redirect_to root_path
  end

end
