# encoding: utf-8
module OrdersHelper

  def read_cost(order)
    if order.cost == 0 || order.cost == nil
      cost = 'Не установлена'
    else 
      cost = number_to_currency(order.cost, :unit => "коп.", :separator => " руб. ")
    end
    return cost
  end
  
  def read_product_background_image(document)
    if document.paper_specification.product_backgrounds.first.image_url
      return (image_tag document.paper_specification.product_backgrounds.first.image_url)
    else 
      return 'Нет изображения продукта'
    end
  end
  

  
end