class Category < ActiveRecord::Base

  has_many :articles, :dependent => :destroy

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

end
