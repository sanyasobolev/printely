# encoding: utf-8
class Lists::ProductBackground < ActiveRecord::Base
  mount_uploader :image, ProductBackgroundUploader

  has_and_belongs_to_many :paper_specifications

  validates :title, :presence => {
     :message => "Не должно быть пустым."
  }

  validates :image, :presence => {
                    :message => "Не должно быть пустым."
                    },
                    :on => :create
         
end
