class Letter < ActiveRecord::Base

  #длины полей
  NAME_MIN_LENGTH = 3
  NAME_MAX_LENGTH = 255
  NAME_RANGE = NAME_MIN_LENGTH..NAME_MAX_LENGTH

  COMPANY_MIN_LENGTH = 3
  COMPANY_MAX_LENGTH = 255
  COMPANY_RANGE = COMPANY_MIN_LENGTH..COMPANY_MAX_LENGTH

  PHONE_MIN_LENGTH = 3
  PHONE_MAX_LENGTH = 255
  PHONE_RANGE = PHONE_MIN_LENGTH..PHONE_MAX_LENGTH

  EMAIL_MIN_LENGTH = 3
  EMAIL_MAX_LENGTH = 255
  EMAIL_RANGE = EMAIL_MIN_LENGTH..EMAIL_MAX_LENGTH

  #размер боксов полей в форме
  NAME_SIZE = 60
  COMPANY_SIZE = 60
  PHONE_SIZE = 60
  EMAIL_SIZE = 60
  QUESTION_COLS_SIZE = 45
  QUESTION_ROWS_SIZE = 20

  #проверка полей
  validates :name,
            :phone,
            :email,
            :question,
            :presence => {:if => nil}

  validates :name, :length => {
    :within => NAME_RANGE,
    :allow_blank => true
  }

  validates :phone, :length => {
    :within => PHONE_RANGE,
    :allow_blank => true
  }

  validates :email, :length => {
    :within => EMAIL_RANGE,
    :allow_blank => true
  }

end
