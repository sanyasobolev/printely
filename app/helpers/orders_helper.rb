module OrdersHelper

  def page_about_download
    @page_about_download = Page.find_by_id('3', :conditions => "published=true")
  end

  def create_form_for_upload
    @documents = @order.documents.build
    render @documents
  end

end
