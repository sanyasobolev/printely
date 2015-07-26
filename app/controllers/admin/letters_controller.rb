# encoding: utf-8
class Admin::LettersController < ApplicationController
  
  def index
    @title = 'Администрирование - Обратная связь'
    @letters = Letter.find(:all, :order => 'created_at DESC')
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

  
end
