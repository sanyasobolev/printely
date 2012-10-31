class Category < ActiveRecord::Base

  has_many :articles, :dependent => :destroy

  before_create :create_permalink
  before_save :update_permalink

  #максмимальные и минимальные значения для полей
  NAME_MAX_LENGTH = 80

  #размер боксов полей в формах
  NAME_SIZE = 60

  # поля должны быть не пустыми
  validates :name,
            :presence => true

  #проверка длины строк
  validates :name, :length => {
    :maximum => NAME_MAX_LENGTH
  }

  # поля должны быть уникальны
  validates :name,
            :permalink,
            :uniqueness => true

  #транслитерация названия категории в ссылку
  def create_permalink
    @attributes['permalink'] = name.parameterize
  end

  def update_permalink
    self.permalink = name.parameterize
  end

  def to_param
    permalink
  end

end
