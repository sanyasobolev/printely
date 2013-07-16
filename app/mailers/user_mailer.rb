# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "info@printely.ru"

  #рассылка при регистрации нового пользователя
  def welcome_email(user)
    @user = user
    @url  = "http://printely.ru/myoffice"
    mail(:to => user.email, :subject => "Вы успешно зарегистрированы на сайте Printely.ru!")
  end

  #рассылка при изменении статуса заказа
  def email_user_about_change_status(order)
    @order = order
    @url_myoffice  = "http://printely.ru/myoffice"
    @url_show_order  = "http://printely.ru/orders/#{order.id}"
    @user = User.find_by_id(order.user_id)
    mail(:to => @user.email, :subject => "Заказ №#{order.id} #{order.status}")
  end


  #рассылка всем админам о регистрации нового юзера
   def self.email_all_admins_about_new_user(new_user)
     @admins = User.where(:role_id => "1")
     @admins.each do |admin|
       email_about_new_user(admin, new_user).deliver
     end
   end

  def email_about_new_user(recipient, new_user)
    mail(:to => recipient.email, :subject => "Зарегистрирован новый пользователь - #{new_user.first_name} #{new_user.second_name}")
  end

   #рассылка всем админам о новом заказе
   def self.email_all_admins_about_new_order(new_order)
     @admins = User.where(:role_id => "1")
     @admins.each do |admin|
       email_about_new_order(admin, new_order).deliver
     end
   end


  def email_about_new_order(recipient, new_order)
    mail(:to => recipient.email, :subject => "Новый заказ №#{new_order.id}")
  end

   #рассылка всем админам о новом письме (обратная связь)
   def self.email_all_admins_about_new_letter(new_letter)
     @admins = User.where(:role_id => "1")
     @admins.each do |admin|
       email_about_new_letter(admin, new_letter).deliver
     end
   end


  def email_about_new_letter(recipient, new_letter)
    mail(:to => recipient.email, :subject => "Новое письмо от пользователя - #{new_letter.name}")
  end

end
