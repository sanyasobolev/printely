# encoding: utf-8
module ApplicationHelper
  def boardlinks
    @first = "<div class=\"boardlink\"> #{link_to "Главная", :root, :class => 'boardlink'}</div>"
    @separator = "<div class = \"boardseparator\"> #{image_tag("icons/separator.png")}</div>"
    @current_controller = controller_name
    @current_action = action_name
    if @current_action == 'index'
      case @current_controller
      when 'services'
        @second = "<div class=\"boardtext\"> Услуги </div>"
        @str = @first + @separator + @second
        return @str.html_safe
      when 'subservices'
          service_title = Service.find_by_permalink(params[:service_id]).title
          @second = "<div class=\"boardlink\"> #{link_to "Услуги", services_path, :class => 'boardlink' } </div>"
          @third = "<div class=\"boardtext\"> #{service_title} </div>"
          @str = @first + @separator + @second + @separator +@third
          return @str.html_safe
      when 'articles'
        if params[:category_id]
          @second = "<div class=\"boardlink\"> #{link_to "Статьи", articles_path, :class => 'boardlink' } </div>"
          category_title = Category.find_by_permalink(params[:category_id]).name
          @third = "<div class=\"boardtext\"> #{category_title} </div>"
        else
          @second = "<div class=\"boardtext\"> Статьи </div>"
          @third = "<div class=\"boardtext\"> Все </div>"
        end
        @str = @first + @separator + @second +@separator + @third
        return @str.html_safe
      else
      return
      end
    end

  if @current_action == 'show'
    case @current_controller
    when 'subservices'
        current_service = Service.find_by_permalink(params[:service_id])
        subservice_title = Subservice.find_by_permalink(params[:id]).title
        @second = "<div class=\"boardlink\"> #{link_to "Услуги", services_path, :class => 'boardlink' } </div>"
        @third = "<div class=\"boardlink\"> #{link_to current_service.title, service_subservices_path(current_service), :class => 'boardlink'} </div>"
        @fourth = "<div class=\"boardtext\"> #{subservice_title} </div>"
        @str = @first + @separator + @second + @separator + @third + @separator + @fourth
        return @str.html_safe
    when 'articles'
      article_title = Article.find_by_permalink(params[:id]).title
      @second = "<div class=\"boardlink\"> #{link_to "Статьи", articles_path, :class => 'boardlink' } </div>"
      @third = "<div class=\"boardtext\"> #{article_title} </div>"
      @str = @first + @separator + @second + @separator + @third
      return @str.html_safe
    else
    return
  end
  end
  end
  end
