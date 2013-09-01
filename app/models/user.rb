# encoding: utf-8
class User < ActiveRecord::Base
  
  attr_accessible :id, :first_name, :second_name, :email, :phone, :password, :password_confirmation, :role_id, :current_password

  require 'digest/sha1'
  
  has_many :articles
  belongs_to :role
  has_many :pages
  has_many :orders, :dependent => :destroy

  #константы---------------------------------------------------------------------------------
  #максмимальные и минимальные значения для полей
  FIRST_AND_SECOND_NAME_MIN_LENGTH = 3
  FIRST_AND_SECOND_NAME_MAX_LENGTH = 30
  FIRST_AND_SECOND_NAME_RANGE = FIRST_AND_SECOND_NAME_MIN_LENGTH..FIRST_AND_SECOND_NAME_MAX_LENGTH

  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 40
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH

  EMAIL_MAX_LENGTH = 50

  PHONE_MAX_LENGTH = 11

  #константа для разрешения ввода русских симоволов в поля формы
  RUSSIAN_ABC = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщьъыэюя'

  #размер боксов полей в форме регистрации
  FIRST_AND_SECOND_NAME_SIZE = 30
  EMAIL_SIZE = 30
  PHONE_SIZE = 30
  PASSWORD_SIZE = 30

# проверка имени и фамилии--------------------------------------------------------------------
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
      :with => /^[#{RUSSIAN_ABC}A-Z\-}]*$/i,
      :message => "Можно только буквы и знаки тире."
    }

  # проверка email--------------------------------------------------------------------------------
    validates :email, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :email, :format => {
      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
      :message => "Email введен неправильно."
    }
    
    validates :email, :uniqueness => {
      :message => 'Такой email уже зарегистрирован.'
    }

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
    validates :password, :presence => {
      :message => "Не должно быть пустым."
    }
    
    validates :password, :format => {
      :with => /[A-Za-z0-9]/,
      :message => "Можно только цифры и буквы латинского алфавита."
    }
    
    validates :password, :confirmation => {
      :message => "Подтвердите пароль."
    }

  #создание виртуальных атрибутов current_password и password
  attr_accessor :current_password
  #attr_accessor :password_confirmation - не нужен, т.к. validates_confirmation_of автоматически проверяет password_confirmation
	#эквивалент attr_accessor :password
	#---------------------------------------------------//
  def password #делаем переменную @password доступной для чтения
    @password
  end

  def password=(pwd) #делаем переменную @password доступной для записи
    @password = pwd
    create_new_salt #создаем случайное число
    self.hashed_password = User.encrypted_password(self.password, self.salt) #шифруем пароль
  end
	#---------------------------------------------------//

  def self.authenticate(email, password)
    user = self.find_by_email(email) #ищем юзера с введенным майлом
    if user                          #если юзер есть в БД
      expected_password = encrypted_password(password, user.salt) #шифруем пароль, полученный от пользователя
      if user.hashed_password != expected_password #если пароль пользователя в БД не равен полученному
      user = nil #очищаем переменную
      end
    end
    user #если все правильно, то результат метода-объект пользователя
  end

  def remember_me
  	self.remember_token_expires_at = 4.week.from_now.utc #время, на которое нужно запомнить сессию
  	create_new_salt
  	self.remember_token = User.encrypted_password(self.remember_token_expires_at, self.salt) #будущие куки
  	save()
  end

  def forget_me #забыть пользователя
  	self.remember_token_expires_at = nil
  	self.remember_token = nil
    save()
  end

  def remember_token? #проверка, что маркер не просрочен
  	remember_token_expires_at && (Time.now.utc < remember_token_expires_at)
  end

  def password_required? #it is performed if no password is currently stored in the database, or if the user is trying to change their password.
    self.hashed_password.blank? || !self.password.blank?
  end

  def has_role?(rolename) #проверка роли пользователя
    self.role.name == rolename ? true : false
  end

  def correct_password?(params) #возвращает true, если старый пароль верный
    current_password = params[:user][:current_password]
    expected_current_password = User.encrypted_password(current_password, self.salt)
    self.hashed_password == expected_current_password
  end

  def password_errors(params) #генерация сообщения об ошибке при неправильном вводе старого пароля
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid? #проверка соответстсвия и генерация error_massages
    # если current_password то генерим сообщение
      errors.add(:current_password, "is incorrect")
  end

  private

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash) #шифрование при помощи инструментов внешней библиотеки
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s #берем ид пользователя и складываем со случайной строкой
  end

end
