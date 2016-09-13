# encoding: utf-8
class Page < ActiveRecord::Base

  before_create :create_permalink
  before_save :update_permalink
  before_save :update_published_at

  belongs_to :section
  belongs_to :user
  belongs_to :service
  belongs_to :subservice

  #длины полей
  TITLE_MIN_LENGTH = 3
  TITLE_MAX_LENGTH = 255
  TITLE_RANGE = TITLE_MIN_LENGTH..TITLE_MAX_LENGTH

  BODY_MAX_LENGTH = 20000

  #размер боксов полей в форме
  TITLE_SIZE = 60
  BODY_COLS_SIZE = 60
  BODY_ROWS_SIZE = 20

  #проверка полей
  validates :title,
            :body,
            :presence => true

  validates :title,
            :permalink,
            :uniqueness => true
  
  validates :title, :length => {
    :within => TITLE_RANGE,
    :message => "Слишком длинное название"
  }

  validates :body, :length => {
    :maximum => BODY_MAX_LENGTH,
    :message => "Слишком много символов на странице"
  }

  scope :main_page, -> {find(1)}
  scope :all_pages, -> {where.not(id: 1).order(created_at: :desc)}
  scope :published_pages, -> {all_pages.where(published: true).order(created_at: :asc)}

#транслитерация названия страницы в ссылку
  def create_permalink
    self[:permalink] = title.parameterize
  end

  def update_permalink
    self.permalink = title.parameterize
  end

  def to_param
    permalink
  end

  def update_published_at
    self.published_at = Time.now if published == true
  end

end
