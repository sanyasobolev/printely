class RolesController < ApplicationController

  def index
    @title = 'Роли пользователей'
  	@roles = Role.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
    end
  end

#  def new
#    @role = Role.new
#  end

#  def create
#    @role = Role.new(:name => params[:role][:name])
#      if params[:role][:right_ids]
#        params[:role][:right_ids].each do |right_id|
#          @role.rights << Right.find(right_id)
#        end
#        else
#          flash[:error] = 'нет прав в роли!'
#          redirect_to :action => 'new'
#          return
#      end
#      if @role.save
#        flash[:notice] = 'Роль создана.'
#        redirect_to :action => 'index'
#        else
#          render :action => 'new'
#      end
#  end

  def edit
    @role = Role.find(params[:id])
    @title = "Редактирование роли - #{@role.name}"
  end

  def update
    @role_for_update = Role.find(params[:id])
    if @role_for_update.name == 'Administrator'
      flash[:error] = "Нельзя редактировать роль администратора!"
      redirect_to :action => 'index'
    else
      @role_for_update.rights.clear
#     if params[:role][:right_ids] && @role_for_update.update_attributes(params[:role])
      if params[:role] && @role_for_update.update_attributes(params[:role])
        flash[:notice] = 'Обновление прошло удачно'
        redirect_to :action => 'index'
      else
        flash[:error] = 'Заполните необходимые поля!'
        redirect_to :action => 'edit'
      end
    end

  end


#  def destroy
#    role_for_delete = Role.find(params[:id])
#    if role_for_delete.name == 'Administrator' || role_for_delete.id == 2
#      flash[:error] = "Нельзя удалить роль по умолчанию!"
#    else
#      role_for_delete.destroy
#      flash[:notice] = "Роль удалена!"
#    end
#  	redirect_to :action => 'index'
#  end

end
