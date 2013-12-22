# encoding: utf-8
class MailingsController < ApplicationController
   
   before_filter :set_published_false,
                 :only => [:edit]
   
  def new
    @title = 'Создание рассылки'
    @mailing = Mailing.new
  end

  def create
    @mailing = Mailing.new(params[:mailing])
    @mailing.all_mails = User.all.count
    respond_to do |wants|
      if @mailing.save
        if @mailing.published == true
          UserMailer.mailing_to_all_users(@mailing)
          flash[:notice] = 'Рассылка сохранена и отправлена в очередь на отправку'
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

  def edit
    @title = 'Редактирование рассылки'
  end

  def update
    @mailing = Mailing.find_by_id(params[:id])
    @mailing.attributes = params[:mailing]
    @mailing.sent_mails = 0
    respond_to do |wants|
      if @mailing.save
        if @mailing.published == true
          UserMailer.mailing_to_all_users(@mailing)
          flash[:notice] = 'Рассылка сохранена и отправлена в очередь на отправку'
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

  def destroy
    @mailing = Mailing.find(params[:id])
    @mailing.destroy
    respond_to do |wants|
      flash[:notice] = 'Запись удалена'
      wants.html { redirect_to admin_mailings_path }
      wants.xml { render :nothing => true }
    end
  end

  def admin
    @title = 'Рассылки'
    @mailings = Mailing.find(:all, :order => 'created_at DESC')
  end
  
  private
  
    def set_published_false
      @mailing = Mailing.find_by_id(params[:id])
      if @mailing.published == true
        @mailing.published = false
        @mailing.save
      end
    end
  
  
end
