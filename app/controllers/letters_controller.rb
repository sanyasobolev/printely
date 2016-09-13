# encoding: utf-8
class LettersController < ApplicationController
 layout 'letters', :only => [:sent, :new]

 def sent
    @title = 'Спасибо!'
  end

  def new
    @title = 'Обратная связь'
    @letter = Letter.new
  end

  def create
    @letter = Letter.new(letter_params)
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

 private
  
  def letter_params
    params.require(:letter).permit(:name, :email, :question)
  end

end
