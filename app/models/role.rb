# encoding: utf-8
class Role < ActiveRecord::Base

  attr_accessible :id, :name
  has_many :users
	has_and_belongs_to_many :rights

  validates :name, :uniqueness => {
    :message => 'Такая роль уже есть'
    }
  
  validates :name, :presence => true
end
