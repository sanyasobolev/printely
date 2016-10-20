 # encoding: utf-8
        require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
        namespace :utils do
          desc "change order types"
          task(:change_order_types => :environment) do
            @orders = Order.all
            delivered_orders = 0
              @orders.each do |order|
                    order.update_attribute(:order_type_id, 2) 
                    puts "completed order #{order.id}"
                    delivered_orders = delivered_orders + 1
              end
            puts "all #{@orders.count} orders"
            puts "delivered #{delivered_orders} orders"
          end
        end