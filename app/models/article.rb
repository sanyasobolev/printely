# encoding: utf-8
class Article < ActiveRecord::Base

mount_uploader :article_header_image, ArticleHeaderImageUploader

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
            
  validates :article_header_image, :presence => {
                    :message => "Не должно быть пустым."
                    },
                    :on => :create
         
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

  default_scope {order(published_at: :desc)}
  scope :articles_for_user, -> {where("published=true AND this_news=false").order('created_at DESC')} 
  scope :news_for_user, -> {where("published=true AND this_news=true").order('created_at DESC') }
  scope :news_for_welcome, -> {where("published=true AND this_news=true").order('created_at DESC').limit(2)}
  scope :articles_for_user_with_category, ->(category) { where("category_id=#{category.id.to_i} AND published=true AND this_news=false").order('created_at DESC')}
  scope :show, ->(permalink) {where("published=true AND permalink=?", permalink).first! }

  def update_published_at
    self.published_at = Time.now if published == true
  end

  #транслитерация названия статьи в ссылку
  def create_permalink
    self[:permalink] = title.parameterize
  end

  def update_permalink
    self.permalink = title.parameterize
  end

  def to_param
    permalink
  end

end
