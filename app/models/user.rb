# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  include TheRole::Api::User
  
  has_many :articles
  belongs_to :role
  has_many :pages
  has_many :orders, :dependent => :destroy

  #константы---------------------------------------------------------------------------------
  #максмимальные и минимальные значения для полей
  FIRST_AND_SECOND_NAME_MIN_LENGTH = 3
  FIRST_AND_SECOND_NAME_MAX_LENGTH = 30
  FIRST_AND_SECOND_NAME_RANGE = FIRST_AND_SECOND_NAME_MIN_LENGTH..FIRST_AND_SECOND_NAME_MAX_LENGTH

  PHONE_MAX_LENGTH = 11

  #константа для разрешения ввода русских симоволов в поля формы
  RUSSIAN_ABC = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщьъыэюя'

  #размер боксов полей в форме регистрации
  FIRST_AND_SECOND_NAME_SIZE = 30
  PHONE_SIZE = 30
  
#дублирующая проверка на сервере
#проверка имени и фамилии--------------------------------------------------------------------
    validates :first_name, :second_name, :presence => {
      :message => "Не должно быть пустым."
    }
    
    validates :first_name, :length => {
      :within => FIRST_AND_SECOND_NAME_RANGE,
      :message => "Слишком короткое имя."
      }
 
    validates :second_name, :length => {
      :within => FIRST_AND_SECOND_NAME_RANGE,
      :message => "Слишком короткая фамилия."
    }
 
    validates :first_name, :second_name, :format => {
      :with => /\A[#{RUSSIAN_ABC}A-Z\-}]*\z/i,
      :message => "Можно только буквы и тире."
    }

  # проверка email--------------------------------------------------------------------------------
 #   validates :email, :presence => {
 #     :message => "Не должно быть пустым."
 #   }

   
#    validates :email, :uniqueness => {
 #     :message => 'Такой email уже зарегистрирован.'
#    }

    #проверка телефона
    validates :phone, :presence => {
      :message => "Не должно быть пустым."
    }
    
    validates :phone, :format => {
      :with => /\A(8|\+7)([\d]){10}\Z/,
      :message => "Телефон введен неправильно."
    }
    
    validates :phone, :uniqueness => {
      :message => 'Такой телефон уже зарегистрирован.'
    }

  # проверка password и password_confirmation------------------------------------------------------
 #   validates :password, :presence => {
 #     :message => "Не должно быть пустым."
 #   }
    
 #   validates :password, :format => {
 #     :with => /\A[a-zA-Z0-9]+\z/,
  #    :message => "Можно только цифры и латинские буквы."
 #   }
    
 #   validates :password, :confirmation => {
 #     :message => "Корректно подтвердите пароль."
 #   }
    
#    validates :current_password, :presence => {
 #     :message => "Не должно быть пустым."
#    },
 #   :on => :update
  
  #validate accept agreement
    validates :agreement, :acceptance => {
      :message => "Примите соглашение о конфидециальности."
    }


  #создание виртуальных атрибутов current_password и password
  attr_accessor :agreement
  
  def get_delivery_dates(exclude_order)
    #get delivery dates orders wo keys 10, 40, 50, 51
    delivery_dates = Array.new
    @orders = Order.where(:user_id => self.id).where(["orders.id <> ?", exclude_order.id]).joins(:order_status).where(["lists_order_statuses.key <> ? AND lists_order_statuses.key <> ? AND lists_order_statuses.key <> ? AND lists_order_statuses.key <> ?", 10, 40, 50, 51])
    @orders.each do |order|
      delivery_dates << order.delivery_date
    end
    return delivery_dates
  end

end
