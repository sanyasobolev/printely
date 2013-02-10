module OrdersHelper

  def add_document_link(name)
    link_to_function name do |page| #вызываем новое поле при помощи RJS
      page.insert_html :bottom, :documents, :partial => 'new_document', :object => Document.new
    end
  end

  def page_about_download
    @page_about_download = Page.find_by_id('3', :conditions => "published=true")
  end

end
