# encoding: utf-8
class SitemapController < ApplicationController
  skip_before_filter :login_required, :authorized?
  layout 'sitemap'
  
  def index
    @title = 'Карта сайта'
    @count_in_column = 3 #количество разделов в столбце
    #поиск всех опубликованных разделов
    @sections = Section.find(:all,
                             :conditions => 'published=true')
    i=1
    @left_sections=[]
    @right_sections=[]
    @sections.each do |section|
      if i <= @count_in_column
        @left_sections << section
      elsif i > @count_in_column
        @right_sections << section
      end
      i=i+1
    end
  end
end
