# encoding: utf-8
class Section < ActiveRecord::Base

  has_ancestry

  before_create :create_permalink
  before_save :update_permalink

  has_one :page, :dependent => :nullify
  
  #максмимальные и минимальные значения для полей
  TITLE_MAX_LENGTH = 20

  #размер боксов полей в формах
  TITLE_SIZE = 20

  # поля должны быть не пустыми
  validates :title,
            :position,
            :presence => true

  validates :permalink,
            :title,
            :uniqueness => true



  #проверка длины строк
  validates :title, :length => {
    :maximum => TITLE_MAX_LENGTH,
    :message => "Слишком длинное название"
    }

  
  scope :exclude_self_and_all_child, ->(section) { where.not(id: section.subtree_ids) }

  #транслитерация названия в ссылку
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
