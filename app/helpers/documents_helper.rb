module DocumentsHelper
 
  def thumb_for_doc(document)
    if document.docfile.file.extension == "pdf"
      image_tag(asset_path('uploadify/thumb_pdf.png'), :class => 'thumb') 
    elsif document.docfile.file.extension == "doc" 
      image_tag(asset_path('uploadify/thumb_doc.png'), :class => 'thumb') 
    elsif document.docfile.file.extension == "docx" 
      image_tag(asset_path('uploadify/thumb_docx.png'), :class => 'thumb')
    end
  end
  
  def page_count_for_doc(document)
    if document.docfile.file.extension == "pdf"
      return PDF::Reader.new(document.docfile.file.path).page_count
    elsif document.docfile.file.extension == "doc" || document.docfile.file.extension == "docx" 
      Docsplit.extract_pdf(document.docfile.file.path, :output => "public/uploads/order_#{document.order.id}/temp")
      return PDF::Reader.new("public/uploads/order_#{document.order.id}/temp/#{document.docfile.file.basename}.pdf").page_count
    end
  end
  
end