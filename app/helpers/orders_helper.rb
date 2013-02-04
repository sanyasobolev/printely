module OrdersHelper

  def add_document_link(name)
    link_to_function name do |page| #вызываем новое поле при помощи RJS
      page.insert_html :bottom, :documents, :partial => 'new_document', :object => Document.new
    end
  end

end
