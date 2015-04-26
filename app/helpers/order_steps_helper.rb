module OrderStepsHelper
  
  def tutorial_progress_bar
    n = 0
    content_tag(:div, class: "wizard_navigator") do
          wizard_steps.collect do |every_step|
            n += 1
            class_str = "unfinished"
            class_str = "current"  if every_step == step
            class_str = "finished" if past_step?(every_step)
            concat(
              content_tag(:div, class: "wizard_step #{class_str} #{every_step}") do
                content_tag(:span, "#{n}", class: "number")+t("order_steps.wiked.#{every_step}")
              end 
            ) 
        end 
    end
  end
 
  
end
