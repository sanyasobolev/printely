#encoding: utf-8
class SvgConverter < Prawn::Document
  
  
  def to_pdf(order, canvas_settings)

      font_families.update("Arial" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/arial_full.ttf",
                               :bold => "#{Rails.root.to_s}/app/assets/fonts/arial_bold_full.ttf",
                               :italic => "#{Rails.root.to_s}/app/assets/fonts/arial_italic_full.ttf",
                               :bold_italic => "#{Rails.root.to_s}/app/assets/fonts/arial_bold_italic_full.ttf" 
                                          })
      font_families.update("Times New Roman" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/times_new_roman_full.ttf",
                               :bold => "#{Rails.root.to_s}/app/assets/fonts/times_new_roman_bold_full.ttf",
                               :italic => "#{Rails.root.to_s}/app/assets/fonts/times_new_roman_italic_full.ttf",
                               :bold_italic => "#{Rails.root.to_s}/app/assets/fonts/times_new_roman_bold_italic_full.ttf"                                                                            
                                          }) 
      font_families.update("Courier New" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/courier_new.ttf"
                                          })
      font_families.update("Calibri" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/calibri.ttf"
                                          })                                          
      font_families.update("Asylbek" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/asylbek.ttf"
                                          })
      font_families.update("Majestic" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/majestic.ttf"
                                          })
      font_families.update("Monotype Corsiva" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/monotype_corsiva.ttf"
                                          })
      font_families.update("Romashulka" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/romashulka.ttf"
                                          })
      font_families.update("Rosa Marena" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/rosa_marena.ttf"
                                          })
      font_families.update("Segoe Print" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/segoe_print.ttf"
                                          })                                          
      font_families.update("Trafaret" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/trafaret.ttf"
                                          }) 
      font_families.update("Vivaldi" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/vivaldi.ttf"
                                          }) 
      font_families.update("Xiomara" => {
                               :normal => "#{Rails.root.to_s}/app/assets/fonts/xiomara.ttf"
                                          })
      
      svg File.read("#{Rails.root}/public/uploads/order_#{order.id}/svg/svg_canvas.svg"), 
                          :at => [0, canvas_settings.height],
                          :width => canvas_settings.width,
                          :height => canvas_settings.height
      render
  end
  
end