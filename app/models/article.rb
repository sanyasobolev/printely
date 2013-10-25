# encoding: utf-8
class Article < ActiveRecord::Base

attr_accessible :title, :synopsis, :body, :category_id, :published, :header_image

#paperclipe
has_attached_file :header_image,
                  :url => "/assets/articles/:basename.:extension",
                  :path => ":rails_root/app/assets/images/articles/:filename"

belongs_to :user
belongs_to :category

before_save :update_published_at
before_create :create_permalink
before_save :update_permalink

#максмимальные и минимальные значения для полей
TITLE_MAX_LENGTH = 255
SYNOPSIS_MAX_LENGTH = 1000
BODY_MAX_LENGTH = 20000

#размер боксов полей в формах
TITLE_SIZE = 60
SYNOPSIS_ROWS_SIZE = 4
SYNOPSIS_COLS_SIZE = 60
BODY_ROWS_SIZE = 20
BODY_COLS_SIZE = 60

# поля должны быть не пустыми
  validates :title,
            :synopsis,
            :body,
            :category_id,
            :presence => true

 # поля должны быть уникальны
  validates :title,
            :permalink,
            :uniqueness => true

#проверка длины строк
  validates :title, :length => {
    :maximum => TITLE_MAX_LENGTH
  }
  validates :synopsis, :length => {
    :maximum => SYNOPSIS_MAX_LENGTH
  }
  validates :body, :length => {
    :maximum => BODY_MAX_LENGTH
  }

  #проверка приложенного файла
  validates_attachment :header_image,
                       :presence => true,
                       :content_type => { :content_type => /image/ },
                       :size => { :in => 0..1.megabytes }

  def update_published_at
    self.published_at = Time.now if published == true
  end

  #транслитерация названия статьи в ссылку
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
