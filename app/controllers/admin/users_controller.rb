# encoding: utf-8
class Admin::UsersController < ApplicationController
  
  def index
    @title = 'Администрирование - Пользователи системы'
    @users = params[:role] ? User.where(:role_id => Role.where(:name => params[:role])) : User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
      format.js
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
      wants.html { redirect_to admin_users_path }
      wants.xml { render :nothing => true }
    end
  end
  
end
