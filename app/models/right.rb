# encoding: utf-8
class Right < ActiveRecord::Base

  attr_accessible :id, :name, :controller, :action, :description
  has_and_belongs_to_many :roles

  validates :name,
            :description,
            :controller,
            :action,
            :presence => true

  validates :name, :uniqueness => {
    :message => 'Такое право уже есть'
  }

end
