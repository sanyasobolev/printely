# encoding: utf-8
class Service < ActiveRecord::Base

  attr_accessible :title, :synopsis, :service_header_icon, :service_id, :pricelist, :order_type_id

  #paperclipe
  has_attached_file :service_header_icon,
                    :url => "/assets/services/:basename.:extension",
                    :path => ":rails_root/app/assets/images/services/:filename"

  has_many :subservices, :dependent => :destroy
  has_one :page
  has_many :order_types, :class_name => "Lists::OrderType"

  before_create :create_permalink
  before_save :update_permalink

  #максмимальные и минимальные значения для полей
  TITLE_MAX_LENGTH = 80
  SYNOPSIS_MAX_LENGTH = 255

  #размер боксов полей в формах
  TITLE_SIZE = 60
  SYNOPSIS_ROWS_SIZE = 4
  SYNOPSIS_COLS_SIZE = 60

  # поля должны быть не пустыми
  validates :title,
            :service_header_icon,
            :presence => true

  #проверка длины строк
  validates :title, :length => {
    :maximum => TITLE_MAX_LENGTH
  }

  validates :synopsis, :length => {
    :maximum => SYNOPSIS_MAX_LENGTH
  }

  # поля должны быть уникальны
  validates :title,
            :permalink,
            :uniqueness => true

  #проверка приложенного файла
  validates_attachment :service_header_icon,
                       :content_type => { :content_type => /image/ },
                       :size => { :in => 0..1.megabytes }

  #транслитерация названия услуги в ссылку
  def create_permalink
    @attributes['permalink'] = title.parameterize
  end

  def update_permalink
    self.permalink = title.parameterize
  end

  def to_param
    permalink
  end


end
