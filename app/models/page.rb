class Page < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10

  belongs_to :user
  before_save :update_published_at

  #длины полей
  TITLE_MIN_LENGTH = 3
  TITLE_MAX_LENGTH = 255
  TITLE_RANGE = TITLE_MIN_LENGTH..TITLE_MAX_LENGTH

  BODY_MAX_LENGTH = 10000

  #размер боксов полей в форме
  TITLE_SIZE = 60
  BODY_COLS_SIZE = 60
  BODY_ROWS_SIZE = 20

  #проверка полей
  validates :title,
            :body,
            :section_id,
            :presence => true

  validates :title, :length => {
    :within => TITLE_RANGE,
    :message => "Слишком длинное название"
  }

  validates :body, :length => {
    :maximum => BODY_MAX_LENGTH,
    :message => "Слишком много символов на странице"
  }

#транслитерация названия страницы в ссылку
  def before_create
    @attributes['permalink'] = title.parameterize
  end

  def to_param
    "#{permalink}"
  end

  def update_published_at
    self.published_at = Time.now if published == true
  end

end
