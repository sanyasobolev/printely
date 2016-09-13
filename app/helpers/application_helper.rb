# encoding: utf-8
module ApplicationHelper
  
  def suckerfish(node)
    fuc = lambda do |nodes|
      return "" if nodes.empty?
      return "<ul>" +
        nodes.inject("") do |string, (node, children)|
          string + "<li rel='#{node.id}'>" +
          link_to(node.name, node.path) +
          fuc.call(children) +
          "</li>"
        end +
        "</ul>"
    end
    fuc.call(node.descendants.arrange)
  end
  
  def boardlinks
    @first = "<div class='boardlink'> #{link_to "Главная", :root, :class => 'boardlink'}</div>"
    @separator = "<div class = 'boardseparator'> #{image_tag("icons/separator.png")}</div>"
    @current_controller = controller_name
    @current_action = action_name
    if @current_action == 'index'
      case @current_controller
      when 'services'
        section_title = Section.find_by(controller: @current_controller).title
        @second = "<div class='boardtext'> #{section_title} </div>"
        @str = @first + @separator + @second
        return @str.html_safe
      when 'subservices'
        section_title = Section.find_by(controller: 'services').title
        service_title = Service.find_by(permalink: params[:service_id]).title
        @second = "<div class='boardlink'> #{link_to section_title, services_path, :class => 'boardlink' } </div>"
        @third = "<div class='boardtext'> #{service_title} </div>"
        @str = @first + @separator + @second + @separator +@third
        return @str.html_safe
      when 'articles'
        section_title = Section.find_by(controller: @current_controller).title
        if params[:category_id]
          @second = "<div class='boardlink'> #{link_to section_title, articles_path, :class => 'boardlink' } </div>"
          category_title = Category.find_by(permalink: params[:category_id]).name
          @third = "<div class='boardtext'> #{category_title} </div>"
          @str = @first + @separator + @second + @separator + @third
        else
          @second = "<div class='boardtext'> #{section_title} </div>"
          @str = @first + @separator + @second
        end
        return @str.html_safe
      when 'pages'
        if params[:subsection_id]
          subsection = Subsection.find_by permalink: params[:subsection_id]
          section = subsection.section
          @second = "<div class='boardlink'> #{link_to section.title, section_page_path(section), :class => 'boardlink' } </div>"
          @third = "<div class='boardtext'> #{subsection.title} </div>"
          @str = @first + @separator + @second + @separator + @third
          return @str.html_safe
        end
      when 'sitemap'
        @second = "<div class='boardtext'> Карта сайта </div>"
        @str = @first + @separator + @second
        return @str.html_safe
      when 'orders'
        @second = "<div class='boardtext'> #{link_to image_tag("icons/my_office_black.png", :border => 0), myoffice_path} </div>"
        @str = @first + @separator + @second
        return @str.html_safe
      else
      return
      end
    end

  if @current_action == 'show'
    case @current_controller
    when 'subservices'
        section_title = Section.find_by(controller: 'services').title
        current_service = Service.find_by permalink: params[:service_id]
        subservice_title = Subservice.find_by(permalink: params[:id]).title
        @second = "<div class='boardlink'> #{link_to section_title, services_path, :class => 'boardlink' } </div>"
        @third = "<div class='boardlink'> #{link_to current_service.title, service_subservices_path(current_service), :class => 'boardlink'} </div>"
        @fourth = "<div class='boardtext'> #{subservice_title} </div>"
        @str = @first + @separator + @second + @separator + @third + @separator + @fourth
        return @str.html_safe
    when 'pages'
        if params[:section_id] && !params[:subsection_id] #if click on section
          section_title = Section.find_by(permalink: params[:section_id]).title
          @second = "<div class='boardtext'> #{section_title} </div>"
          @str = @first + @separator + @second
          return @str.html_safe
        elsif params[:id]
          current_page = Page.find_by permalink: params[:id]
          if current_page && current_page.subsection
            subsection = current_page.subsection
            section = subsection.section
            @second = "<div class='boardtext'> #{link_to section.title, section_page_path(section), :class => 'boardlink'} </div>"
            @third = "<div class='boardtext'> #{link_to subsection.title, section_subsection_pages_path(section, subsection), :class => 'boardlink'} </div>"
            @fourth = "<div class='boardtext'> #{current_page.title} </div>"
            @str = @first + @separator + @second + @separator + @third + @separator + @fourth
          elsif !current_page
            section = Section.find_by permalink: params[:section_id]
            subsection = Subsection.find_by permalink: params[:subsection_id]
            @second = "<div class='boardtext'> #{link_to section.title, section_page_path(section), :class => 'boardlink'} </div>"
            @third = "<div class='boardtext'> #{link_to subsection.title, section_subsection_pages_path(section, subsection), :class => 'boardlink'} </div>"
            @str = @first + @separator + @second + @separator + @third
          else
            @second = "<div class='boardtext'> #{current_page.title} </div>"
            @str = @first + @separator + @second
          end
        return @str.html_safe
        end
    when 'articles'
        article_title = Article.find_by(permalink: params[:id]).title
      unless params[:item] == 'news'
        @second = "<div class='boardlink'> #{link_to "статьи", articles_path, :class => 'boardlink' } </div>"
        @third = "<div class='boardtext'> #{article_title} </div>"
        @str = @first + @separator + @second + @separator + @third
      else
        @second = "<div class='boardtext'> #{article_title} </div>"
        @str = @first + @separator + @second    
      end

      return @str.html_safe
    when 'orders'
      @second = "<div class='boardlink'> #{link_to image_tag("icons/my_office_black.png", :border => 0), myoffice_path}</div>"
      @third = "<div class='boardlink'> #{link_to "Мои заказы", my_orders_path, :class => 'boardlink' } </div>"
      @fourth = "<div class='boardtext'> Заказ №#{Order.find(params[:id]).id} </div>"
      @str = @first + @separator + @second + @separator + @third + @separator + @fourth
      return @str.html_safe
    else
    return
    end
  end

  if @current_action == 'new' || @current_action == 'sent' || @current_action == 'create'
    case @current_controller
    when 'letters'
      @second = "<div class='boardtext'> Обратная связь </div>"
      @str = @first + @separator + @second
      return @str.html_safe
    when 'sessions'
      @second = "<div class='boardtext'> Вход в систему </div>"
      @str = @first + @separator + @second
      return @str.html_safe
    when 'users'
      @second = "<div class='boardtext'> Регистрация </div>"
      @str = @first + @separator + @second
      return @str.html_safe
    end
  end
   if @current_action == 'my'
    case @current_controller
    when 'orders'
        @second = "<div class='boardlink'> #{link_to image_tag("icons/my_office_black.png", :border => 0), myoffice_path}</div>"
        @third = "<div class='boardlink'> Мои заказы </div>"
        @str = @first + @separator + @second + @separator + @third
        return @str.html_safe
    end
   end
   
   if @current_action == 'forgot_password'
      @second = "<div class='boardtext'> #{link_to 'Вход в систему', :login, :class => 'boardlink'} </div>"
      @third = "<div class='boardlink'> Сброс пароля </div>"
      @str = @first + @separator + @second + @separator + @third
      return @str.html_safe
   end
   
   if @current_action == 'edit'
     case @current_controller
     when 'users'
        @second = "<div class='boardlink'> #{link_to image_tag("icons/my_office_black.png", :border => 0), myoffice_path}</div>"
        @third = "<div class='boardlink'> Изменение данных пользователя </div>"
        @str = @first + @separator + @second + @separator + @third
        return @str.html_safe
     end
   end
   
  if @current_action == 'edit_profile'
      @second = "<div class='boardlink'> #{link_to image_tag("icons/my_office_black.png", :border => 0), myoffice_path}</div>"
      @third = "<div class='boardlink'> #{ link_to 'Изменение данных пользователя', edit_user_path(User.find(params[:id])), :class => 'boardlink'} </div>"
      @fourth = "<div class='boardtext'> Изменение профиля </div>"
      @str = @first + @separator + @second + @separator + @third + @separator + @fourth
      return @str.html_safe
   end

  if @current_action == 'edit_password' || @current_action == 'update_password'
      @second = "<div class='boardlink'> #{link_to image_tag("icons/my_office_black.png", :border => 0), myoffice_path}</div>"
      @third = "<div class='boardlink'> #{ link_to 'Изменение данных пользователя', edit_user_path(User.find(params[:id])), :class => 'boardlink'} </div>"
      @fourth = "<div class='boardtext'> Изменение пароля </div>"
      @str = @first + @separator + @second + @separator + @third + @separator + @fourth
      return @str.html_safe
   end
  end
  
  def boolean_to_ru(boolean)
    if boolean == true
      "Да"
    else
      "Нет"
    end
  end
  
  def density_to_ru(density)
    if density
      "#{density} г/м<sup>2</sup>".html_safe
    end
  end
  
  def admin_menu
    if current_user && current_user.has_role?(:admin, :settings_button)
      render :partial => 'share/admin_menu'
    end    
  end
  

end
