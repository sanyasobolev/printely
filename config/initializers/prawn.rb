require "prawn"
#add fonts to prawn svg
Prawn::Svg::Interface.font_path << "#{Rails.root.to_s}/app/assets/fonts"