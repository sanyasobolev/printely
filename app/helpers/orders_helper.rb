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
  
  def read_cost_min_max(object) #order or order.scan
    if object.cost_min == nil && object.cost_max == nil
      cost_min = ''
      cost_max = 'Не установлена'
    else
      if object.cost_min != object.cost_max
        cost_min = "#{Order.human_attribute_name('cost_min')} " +
        number_to_currency(object.cost_min, :unit => "руб.", delimiter: "", precision: 0) +
        "<br />" + " #{Order.human_attribute_name('cost_max')} "
      else
        cost_min = ''
      end
      cost_max = number_to_currency(object.cost_max, :unit => "руб.", delimiter: "", precision: 0)
    end
    cost_min_max = cost_min + cost_max
    return cost_min_max.html_safe
  end
  
end