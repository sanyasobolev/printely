# encoding: utf-8
class Section < ActiveRecord::Base

  before_create :create_permalink
  before_save :update_permalink

  has_many :pages, :dependent => :destroy

  SECTION_ORDER = [1,2,3,4,5,6]

  #максмимальные и минимальные значения для полей
  TITLE_MAX_LENGTH = 10

  #размер боксов полей в формах
  TITLE_SIZE = 20

  # поля должны быть не пустыми
  validates :title,
            :order,
            :presence => true

  validates :order, 
            :permalink,
            :title,
            :uniqueness => true


  #проверка длины строк
  validates :title, :length => {
    :maximum => TITLE_MAX_LENGTH,
    :message => "Слишком длинное название"
    }

  #транслитерация названия в ссылку
  def create_permalink
    @attributes['permalink'] = title.parameterize
  end

  def update_permalink
    self.permalink = title.parameterize
  end

  def to_param
    permalink
  end


end
