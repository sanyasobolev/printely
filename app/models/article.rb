class Article < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 3

belongs_to :user
belongs_to :category
before_save :update_published_at

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

  def update_published_at
    self.published_at = Time.now if published == true
  end


end
