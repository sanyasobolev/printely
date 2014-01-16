# encoding: utf-8
module Lists::PaperSpecificationsHelper
  
    def prices_list(pspec)
      list = "<ul>"
      prices = Array.new
      pspec.document_specifications.each do |document_specification|
        prices << document_specification.price if document_specification.available == true
      end
      prices = prices.uniq
      if prices.count == 1
          list += "<li>" + "#{number_to_currency(prices.first, :unit => "руб.", delimiter: ".", precision: 2)}" + "</li>"
      else
        pspec.document_specifications.each do |document_specification|
          list += "<li>" + "#{number_to_currency(document_specification.price, :unit => "руб.", delimiter: ".", precision: 2)}" + "</li>"
        end
      end
      list += "</ul>"
      return list.html_safe
    end
  
end
