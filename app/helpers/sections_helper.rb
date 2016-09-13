module SectionsHelper
  
  def nested_list_sections(sections)
    content_tag :ul do
      sections.map do |section, sub_sections|
        #есть ли дочерние разделы
        nested_list = sub_sections.size == 0 ? nil : nested_list_sections(sub_sections)
        
        #если есть, то устанавливаем класс родительского раздела
        li_class = nested_list.nil? ? nil : "has-sub"
        
        #если есть и уровень родительского раздела 0, то показываем трегольник вниз
        arrow_down = (!nested_list.nil? && section.depth == 0) ? content_tag(:span, nil, class: "arrow-down") : nil
        
        #если есть и уровень родительского раздела 1, то показываем трегольник вправо
        arrow_right = (!nested_list.nil? && section.depth == 1) ? content_tag(:span, nil, class: "arrow-right") : nil
        
        content_tag(:li, render(:partial => "sections/section", :locals => {:section => section, :arrow_down => arrow_down, :arrow_right => arrow_right}) + nested_list, class: li_class)
      end.join.html_safe      
    end
  end
  
end
