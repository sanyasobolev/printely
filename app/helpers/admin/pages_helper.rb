module Admin::PagesHelper
  
  def section_for_page #возвращает перечень всех созданных пользователем разделов
    Section.find(:all, :conditions => "controller='no'")
  end
  
  def subsection_for_page #возвращает перечень всех созданных пользователем подразделов
    Subsection.find(:all, :conditions => "controller='no'")
  end
  
end
