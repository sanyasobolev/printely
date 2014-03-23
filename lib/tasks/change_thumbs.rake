 # encoding: utf-8
        require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
        require 'fileutils'
        namespace :utils do
          desc "change thumbs"
          task(:change_thumbs => :environment) do
            @orders = Order.all
            delivered_orders = 0
            id=0
              @orders.each do |order|
                id = order.id.to_i
                FileUtils.mv("public/uploads/order_#{id}", 'public/uploads/thumbs')
                Dir.mkdir( "public/uploads/order_#{id}")
                FileUtils.mv('public/uploads/thumbs/', "public/uploads/order_#{id}/")
                puts "completed order #{order.id}"
                delivered_orders = delivered_orders + 1
              end
            puts "all #{@orders.count} orders"
            puts "delivered #{delivered_orders} orders"
          end
        end