# encoding: utf-8
class Letter < ActiveRecord::Base

  attr_accessible :name, :email, :question

  #длины полей
  NAME_MIN_LENGTH = 3
  NAME_MAX_LENGTH = 255
  NAME_RANGE = NAME_MIN_LENGTH..NAME_MAX_LENGTH

  #проверка полей
  validates :name,
            :email,
            :question,
            :presence => {:if => nil}

    validates :name, :length => {
      :within => NAME_RANGE,
      :message => "Слишком короткое ФИО."
      }

    validates :email, :format => {
      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
      :message => "Email введен неправильно."
    }

    validates :question, :length => {
      :within => 3..1000,
      :message => "Длина сообщения от 3 до 1000 знаков."
    }

end
