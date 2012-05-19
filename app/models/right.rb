class Right < ActiveRecord::Base

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
