module Admin::PagesHelper
  
  def section_for_page #возвращает перечень всех созданных пользователем разделов
    Section.sections_for_pages
  end
  
end
