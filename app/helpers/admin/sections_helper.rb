module Admin::SectionsHelper
  
  def nested_sections(sections)
    sections.map do |section, sub_sections|
      content_tag(:div, render(:partial => "admin/sections/section", :locals => {:section => section}), :class => "sections") + content_tag(:div, nested_sections(sub_sections), :class => "nested_sections")
    end.join.html_safe
  end
  
  def parent_sections
    ancestry_options(Section.exclude_self_and_all_child(@section).arrange(:order => 'title')) {|i| "#{'-' * i.depth} #{i.title}" }
  end
  
  def ancestry_options(items, &block)
    return ancestry_options(items){ |i| "#{'-' * i.depth} #{i.title}" } unless block_given?

    result = []
    items.map do |item, sub_items|
      result << [yield(item), item.id]
      #this is a recursive call:
      result += ancestry_options(sub_items, &block)
    end
    result
  end
  
end
