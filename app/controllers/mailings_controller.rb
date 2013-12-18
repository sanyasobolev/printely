# encoding: utf-8
class MailingsController < ApplicationController
   
  def new
    @title = 'Создание расылки'
    @mailing = Mailing.new
  end

  def create
    @mailing = Mailing.new(params[:mailing])
    @mailing.all_mails = User.all.count
    respond_to do |wants|
      if @mailing.save
        if params[:mailing][:published] == 1
          UserMailer.mailing_to_all_users(@mailing)
          flash[:notice] = 'Рассылка сохранена и отправлена в очередь.'
        else
          flash[:notice] = 'Рассылка сохранена как черновик'
        end
        wants.html { redirect_to admin_mailings_path }
        wants.xml { render :xml => @mailing.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @mailing.errors}
      end
    end
  end

  def show
    @title = 'Письмо клиента'
    @letter = Letter.find_by_id(params[:id])
    respond_to do |wants|
      wants.html
      wants.xml { render :xml => @letter.to_xml }
    end
  end

  def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    respond_to do |wants|
      flash[:notice] = 'Запись удалена'
      wants.html { redirect_to admin_letters_path }
      wants.xml { render :nothing => true }
    end
  end

  def admin
    @title = 'Рассылки'
    @mailings = Mailing.find(:all, :order => 'created_at DESC')
  end
  
  
  
end
