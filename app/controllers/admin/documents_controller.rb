# encoding: utf-8
class Admin::DocumentsController < ApplicationController
  
  def download_pdf
    @document = Document.find(params[:id])
    output = SvgConverter
                  .new(:page_size => [@document.get_canvas_setting.width,@document.get_canvas_setting.height],:margin => 0)
                  .to_pdf(@document.order, @document.get_canvas_setting)
    send_data output, :type => 'application/pdf', :filename => "document.pdf"
  end

end
