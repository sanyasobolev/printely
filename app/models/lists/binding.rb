# encoding: utf-8
class Lists::Binding < ActiveRecord::Base
   
   has_many :documents
   has_many :paper_specifications, :through => :documents
   
    validates :binding, :presence => {
      :message => "Не должно быть пустым."
    }

    validates :binding, :uniqueness => {
      :message => 'Такое значение уже есть.'
    }
end
