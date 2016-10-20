# encoding: utf-8
module DocumentsHelper

require 'ole/storage'

  def thumb_for_doc(document)
    if document.docfile.file.extension == "pdf"
      image_tag(asset_path('uploadify/thumb_pdf.png'), :class => 'document_uploaded_thumb') 
    elsif document.docfile.file.extension == "doc" 
      image_tag(asset_path('uploadify/thumb_doc.png'), :class => 'document_uploaded_thumb') 
    elsif document.docfile.file.extension == "docx" 
      image_tag(asset_path('uploadify/thumb_docx.png'), :class => 'document_uploaded_thumb')
    elsif document.docfile.file.extension == "ppt" 
      image_tag(asset_path('uploadify/thumb_ppt.png'), :class => 'document_uploaded_thumb')
    elsif document.docfile.file.extension == "pptx" 
      image_tag(asset_path('uploadify/thumb_pptx.png'), :class => 'document_uploaded_thumb')
    end
  end
  
  def page_count_for_doc(document)
    if document.docfile.file.extension == "pdf"
      page_count = PDF::Reader.new(document.docfile.file.path).page_count
      document.page_count = page_count
      document.update_attribute(:page_count, page_count)
      return page_count
    elsif document.docfile.file.extension == "doc" || document.docfile.file.extension == "ppt" 
      ole = Ole::Storage.open(document.docfile.file.path)
      if p ole.meta_data.doc_page_count!= nil
        page_count = p ole.meta_data.doc_page_count
        document.page_count = page_count
        document.update_attribute(:page_count, page_count)
        return page_count
      else
        return false
      end
    end
  end
  
  def product_background_item(order)
    document = order.documents.first
    pspec = document.paper_specification

    item = pspec.product_backgrounds.empty? ? 'Нет изображения макета' : "<img src='"+"#{pspec.product_backgrounds.first.image_url}"+"'>"
    return item.html_safe
  end
    
  
  
end