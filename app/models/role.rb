class Role < ActiveRecord::Base

  has_many :users
	has_and_belongs_to_many :rights

  validates :name, :uniqueness => {
    :message => 'Такая роль уже есть'
    }
  
  validates :name, :presence => true
end
