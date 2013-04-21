# encoding: utf-8
class DocumentsController < ApplicationController
  skip_before_filter :authorized?,
                     :only => [:index, :my, :new, :create, :remove, :show]

  skip_before_filter :verify_authenticity_token,
                     :only => [:create]


  def create
    @document = Document.new(params[:document])
    respond_to do |wants|
        if @document.save
          flash[:notice] = 'Заказ создан успешно.'
        end
      end
  end

end
