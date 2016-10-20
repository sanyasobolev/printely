# encoding: utf-8
class Subservice < ActiveRecord::Base

  belongs_to :service
  has_one :page
  has_one :order_type, :class_name => "Lists::OrderType"

  before_create :create_permalink
  before_save :update_permalink

  mount_uploader :header_icon, HeaderIconUploader

  #максмимальные и минимальные значения для полей
  TITLE_MAX_LENGTH = 80
  SYNOPSIS_MAX_LENGTH = 255

  #размер боксов полей в формах
  TITLE_SIZE = 60
  SYNOPSIS_ROWS_SIZE = 4
  SYNOPSIS_COLS_SIZE = 60

  # поля должны быть не пустыми
  validates :title,
            :service_id,
            :presence => true

  validates :header_icon, :presence => {
                    :message => "Не должно быть пустым."
                    },
                    :on => :create

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
            
   scope :for_service, ->(service) {where("service_id=?", service.id.to_i).order(title: :desc)}

  #транслитерация названия статьи в ссылку
  def create_permalink
    self[:permalink] = title.parameterize
  end

  def update_permalink
    self.permalink = title.parameterize
  end

  def to_param
    permalink
  end
end
