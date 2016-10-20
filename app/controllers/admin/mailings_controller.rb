# encoding: utf-8
class Admin::MailingsController < ApplicationController
   
  before_filter :set_published_false,
                :only => [:edit]

  def index
    @title = 'Рассылки'
    @mailings = Mailing.all
  end
   
  def new
    @title = 'Создание рассылки'
    @mailing = Mailing.new
  end

  def create
    @mailing = Mailing.new(mailing_params)
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
    @mailing = Mailing.find(params[:id])
    @mailing.attributes = mailing_params
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

  private
  
    def set_published_false
      @mailing = Mailing.find(params[:id])
      if @mailing.published == true
         @mailing.published = false
         @mailing.save
      end
    end
    
  def mailing_params
    params.require(:mailing).permit(:subject, :body, :sent_mails, :all_mails, :published)
  end   
 

  
end
