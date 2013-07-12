# encoding: utf-8
class UsersController < ApplicationController
  layout 'signin', :only => [:new, :create]
  
  skip_before_filter :login_required, :authorized?,
                     :only => [:new, :create]

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

  def update
    @user = User.find(params[:id])
    attribute = params[:attribute]
    case attribute
      when "email"
        try_to_update(@user)
      when "password"
        if @user.correct_password?(params)
          try_to_update(@user)
        else
          @user.password_errors(params)
          render :action => "edit"
        end
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
