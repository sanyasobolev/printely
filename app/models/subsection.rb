# encoding: utf-8
class Subsection < ActiveRecord::Base
  attr_accessible :id, :section_id, :title, :order, :controller, :action, :permalink, :published

  before_create :create_permalink
  before_save :update_permalink
  
  belongs_to :section
  has_many :pages, :dependent => :destroy
  
  SUBSECTION_ORDER = [1,2,3,4,5,6,7,8,9,10]

  #максмимальные и минимальные значения для полей
  TITLE_MAX_LENGTH = 20

  # поля должны быть не пустыми
  validates :title,
            :order,
            :section_id,
            :presence => true
  #уникальными
  validates :permalink,
            :title,
            :uniqueness => true

    validates :order, :uniqueness => { 
    :scope => :section_id,
    :message => "Порядковый номер занят."
    }


  #транслитерация названия в ссылку
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
