module SectionsHelper

  def section_for_page #возвращает перечень всех созданных пользователем разделов
    Section.find(:all, :conditions => "controller='no'")
  end
  
end
