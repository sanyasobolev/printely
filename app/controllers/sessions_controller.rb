# encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :login_required, :authorized?

  def new
    @title = 'Вход в систему'
  end

  def create #вход в систему
  	self.current_user = User.authenticate(params[:user][:email], params[:user][:password])
    if logged_in?
      if params[:remember_me] == "1" #если юзер поставил галочку "запомнить меня"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to root_path
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
