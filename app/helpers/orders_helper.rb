module OrdersHelper

  def page_about_download
    @page_about_download = Page.find_by_id('3', :conditions => "published=true")
  end

end
