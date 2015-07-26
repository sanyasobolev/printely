# encoding: utf-8
class UsersController < ApplicationController
  layout 'signin', :only => [:new, :create, :forgot_password, :edit, :edit_profile, :edit_password, :update_password]
  
  skip_before_filter :login_required, :authorized?,
                     :only => [:new, :create, :forgot_password, :reset_password, :check_email, :check_phone, :check_pass]


  def new
    @title = 'Регистрация'
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @user }
    end
  end

  def create #регистрация пользователя
    cookies.delete :auth_token
      # protects against session fixation attacks, wreaks havoc with
      # request forgery protection.
      # uncomment at your own risk
      # reset_session
      # по дефолту все зарегистрированные пользователи имеют роль User на уровне БД.
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        #send email
        UserMailer.welcome_email(@user).deliver
        UserMailer.email_all_admins_about_new_user(@user)
        self.current_user = @user
        format.html { redirect_to :myoffice, :notice => 'Вы успешно зарегистрированы!' }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    @title = "Изменение данных пользователя - #{@user.first_name} #{@user.second_name}"
    if !your_profile?(@user)
      flash[:notice] = 'Вы не можете изменять чужой профиль!'
      redirect_to :controller => :sessions, :action => :new
    end
  end

  def forgot_password
    @title = 'Сброс пароля'
    respond_to do |format|
      format.html
      format.xml { render :xml => @user }
    end
  end
  
  def reset_password
    @user_for_reset = User.find_by_email(params[:user][:email])
    if @user_for_reset != nil
      random_password = SecureRandom.hex(3)
      @user_for_reset.update_attribute('password', random_password)
      flash[:notice] = "Ваш новый пароль направлен Вам на электронную почту."
      UserMailer.reset_password(@user_for_reset, random_password).deliver
      redirect_to :login
    else
      flash[:error] = "Пользователя с таким email у нас пока не зарегистрировано!"
      redirect_to forgot_password_users_path
    end
  end
  
  def edit_password
    @user = User.find(params[:id])
    @title = "Изменение пароля пользователя - #{@user.first_name} #{@user.second_name}"
    if !your_profile?(@user)
      flash[:error] = 'Вы не можете изменять чужой пароль!'
      redirect_to :login
    end
  end

  def update_password
    @user = User.find(params[:id])
    attribute = params[:attribute]
    if params[:attribute] == "password" && your_profile?(@user)
      if @user.correct_password?(params)
        @user.update_attribute("password", params[:user][:password])
        flash[:notice] = 'Ваш пароль изменен успешно!'
        redirect_to edit_user_path(@user)
      else
        flash[:error] = 'Текущий пароль введен неверно.'
        redirect_to edit_password_user_path(@user)
      end    
    else
      flash[:error] = 'Изменение пароля невозможно.'
      redirect_to :login
    end   
  end

  def edit_profile
    @user = User.find(params[:id])
    @title = "Изменение профиля пользователя - #{@user.first_name} #{@user.second_name}"
    if !your_profile?(@user)
      flash[:error] = 'Вы не можете изменять чужой профиль!'
      redirect_to :controller => :sessions, :action => :new
    end
  end
  
  def update_profile
    @user = User.find(params[:id])
    if params[:attribute]== "email" && your_profile?(@user)
      params[:user].each_pair do |key, value|
        @user.update_attribute(key, value)
      end  
      flash[:notice] = 'Ваш профиль изменен успешно!'
      redirect_to edit_user_path(@user) 
    else
      flash[:error] = 'Изменение профиля невозможно.'
      redirect_to :login
    end
  end
  
  def check_email
    user = User.find_by_email(params[:user][:email])
    if user && user != current_user
      msg = "false"
    else
      msg = "true"
    end
    render :text => msg
  end

  def check_phone
    user = User.find_by_phone(params[:user][:phone])
    if user && user != current_user
      msg = "false"
    else
      msg = "true"
    end
    render :text => msg
  end
  
  def check_pass
    if current_user && current_user.correct_password?(params)
      msg = "true"
    else
      msg = "false"
    end
    render :text => msg
  end

private

  def try_to_update(user)
    respond_to do |wants|
      if user.update_attributes(params[:user])
        flash[:notice] = 'Информация обновлена'
        wants.html { redirect_to edit_user_path(user) }
        wants.xml { render :xml => user.to_xml }
      else
        wants.html { render :action => "edit" }
        wants.xml {render :xml => user.errors}
      end
    end
  end

end
