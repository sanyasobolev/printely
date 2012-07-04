# encoding: utf-8
class Section < ActiveRecord::Base

  has_many :pages, :dependent => :destroy

  SECTION_ORDER = [1,2,3,4,5,6,7,8,9,10]

  #максмимальные и минимальные значения для полей
  TITLE_MAX_LENGTH = 10

  #размер боксов полей в формах
  TITLE_SIZE = 20

  # поля должны быть не пустыми
  validates :title,
            :order,
            :presence => true

  validates :order, :uniqueness => true


  #проверка длины строк
  validates :title, :length => {
    :maximum => TITLE_MAX_LENGTH,
    :message => "Слишком длинное название"
    }


end
