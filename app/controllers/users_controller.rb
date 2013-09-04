# encoding: utf-8
class UsersController < ApplicationController
  layout 'signin', :only => [:new, :create, :forgot_password]
  
  skip_before_filter :login_required, :authorized?,
                     :only => [:new, :create, :forgot_password, :reset_password]

  def admin #страница администратора

  end

  def index
    @title = 'Администрирование - Пользователи системы'
    @users = params[:role] ? User.where(:role_id => Role.where(:name => params[:role])) : User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
      format.js
    end
  end

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
    @title = "Редактирование данных пользователя - #{@user.first_name} #{@user.second_name}"
    if !your_profile?(@user)
      flash[:notice] = 'Вы не можете редактировать чужой профиль!'
      redirect_to :controller => :sessions, :action => :new
    end
  end



  def destroy
    user_for_delete = User.find(params[:id])
    respond_to do |wants|
      if user_for_delete == current_user
        flash[:error] = 'Нельзя удалить самого себя!'
        else
        user_for_delete.destroy
      end
      wants.html { redirect_to users_path }
      wants.xml { render :nothing => true }
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
    @title = "Редактирование пароля пользователя - #{@user.first_name} #{@user.second_name}"
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
        render :action => "edit_password"
      end    
    else
      flash[:error] = 'Редактирование профиля невозможно.'
      redirect_to :login
    end   
  end

  def edit_profile
    @user = User.find(params[:id])
    @title = "Редактирование профиля пользователя - #{@user.first_name} #{@user.second_name}"
    if !your_profile?(@user)
      flash[:error] = 'Вы не можете редактировать чужой профиль!'
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
      flash[:error] = 'Редактирование профиля невозможно.'
      redirect_to :login
    end
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
