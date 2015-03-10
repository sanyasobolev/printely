# encoding: utf-8
module OrdersHelper

  def page_about_download
    @page_about_download = Page.find_by_id('3', :conditions => "published=true")
  end
  
  def read_cost(order)
    if order.cost == 0 || order.cost == nil
      cost = 'Не установлена'
    else 
      cost = number_to_currency(order.cost, :unit => "коп.", :separator => " руб. ")
    end
    return cost
  end
  
  def read_document_layout(document)
    if document.paper_specification.layout.url
      return (image_tag document.paper_specification.layout.url)
    else 
      return 'Нет изображения макета'
    end
  end
  
end