# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "noreply@printely.ru"

  #рассылка при регистрации нового пользователя
  def welcome_email(user)
    @user = user
    @myoffice  = "http://printely.ru/myoffice"
    mail(:to => user.email, :subject => "Вы успешно зарегистрированы на сайте Printely.ru!")
  end

  #рассылка при создании нового заказа
  def email_user_about_new_order(order)
    @order = order
    @status = Lists::OrderStatus.where(:id => order.order_status_id).first.title
    @myoffice  = "http://printely.ru/myoffice"
    @url_to_order = "http://printely.ru/orders/#{@order.id}"
    @user = User.find_by_id(order.user_id)
    mail(:to => @user.email, :subject => "Заказ №#{@order.id} создан и находится #{@status}")
  end

  #рассылка при изменении статуса заказа
  def email_user_about_change_status(order)
    @order = order
    @status = Lists::OrderStatus.where(:id => order.order_status_id).first.title
    @myoffice  = "http://printely.ru/myoffice"
    @url_to_order = "http://printely.ru/orders/#{@order.id}"
    @user = User.find_by_id(order.user_id)
    mail(:to => @user.email, :subject => "Заказ №#{@order.id} #{@status}")
  end

  #рассылка при выполнении заказа
  def email_user_about_complete_order(order)
    @order = order
    @status = Lists::OrderStatus.where(:id => order.order_status_id).first.title
    @url_to_letters = "http://printely.ru/letters/new"
    @user = User.find_by_id(order.user_id)
    mail(:to => @user.email, :subject => "Заказ №#{@order.id} #{@status}")
  end
  
  #рассылка при удалении заказа
  def email_user_about_remove_order(order)
    @order = order
    @user = User.find_by_id(order.user_id)
    mail(:to => @user.email, :subject => "Заказ №#{@order.id} будет удален из системы")
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
    @author = new_letter.name
    @body = new_letter.question
    mail(:from => new_letter.email, :to => recipient.email, :subject => "Новое письмо от пользователя. Автор - #{new_letter.name}")
  end
  
   #рассылка всем юзерам системы
   def self.mailing_to_all_users(mailing)
     @users = User.all
     t = 25
     @users.each do |user|
       delay(run_at: t.seconds.from_now).mailing_to_user(user, mailing)
       t = t + 25
     end
   end

  def mailing_to_user(user, mailing)
    @user = user
    @mailing = mailing
    mail(:to => @user.email, :subject => @mailing.subject)
    mailing.sent_mails = mailing.sent_mails + 1
    mailing.save
  end
  
  #рассылка при сбросе пароля
  def reset_password(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => user.email, :subject => "Ваш новый пароль на сайте Printely.ru")
  end

end
