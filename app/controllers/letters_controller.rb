class LettersController < ApplicationController
 skip_before_filter :login_required, :authorized?,
                    :only => [:sent, :new, :create]

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
        flash[:notice] = 'Спасибо! Ваше сообщение сохранено и направлено в администрацию компании.'
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
    @letters = Letter.paginate :page => params[:page],
                               :order => 'created_at DESC',
                               :per_page => '10'
  end
  
end
