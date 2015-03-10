# encoding: utf-8
class Lists::CanvasSetting < ActiveRecord::Base
   attr_accessible :margin_top,
                   :margin_left,
                   :width,
                   :height
                   
   has_and_belongs_to_many :paper_specifications
   
    validates :margin_top, :margin_left, :width, :height, :presence => {
      :message => "Не должно быть пустым."
    }
   
    def canvas_setting_description
      "сверху(#{margin_top}),слева(#{margin_left}),ширина(#{width}),высота(#{height})"
    end 
   
end
