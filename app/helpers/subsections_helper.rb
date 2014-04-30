module SubsectionsHelper
  
  def subsection_for_page #возвращает перечень всех созданных пользователем подразделов
    Subsection.find(:all, :conditions => "controller='no'")
  end
end
