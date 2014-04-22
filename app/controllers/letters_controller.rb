# encoding: utf-8
class LettersController < ApplicationController
 skip_before_filter :login_required, :authorized?,
                    :only => [:sent, :new, :create]
 layout 'letters'

 def sent
    @title = 'Спасибо!'
  end

  def new
    @title = 'Обратная связь'
    @letter = Letter.new
  end

  def create
    @letter = Letter.new(params[:letter])
    respond_to do |wants|
      if @letter.save
        UserMailer.email_all_admins_about_new_letter(@letter)
        flash[:notice] = 'Спасибо! Мы ответим Вам как можно быстрее.'
        wants.html { redirect_to sent_letters_path }
        wants.xml { render :xml => @letter.to_xml }
      else
        wants.html { render :action => "new" }
        wants.xml {render :xml => @letter.errors}
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
    @title = 'Администрирование - Обратная связь'
    @letters = Letter.find(:all, :order => 'created_at DESC')
  end

end
