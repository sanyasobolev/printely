# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

  #Создание роли администратор
  admin_role = Role.create(
                :name => 'admin',
                :title => 'Role for admin',
                :description => 'This user can do anything',
                :the_role => '{"system":{"administrator":true}}'
                )
  
   #создание пользователя-администратора
   admin_user = User.create(:first_name => 'Admin',
                           :second_name => 'system',
                           :email => 'admin@printely.ru',
                           :phone => '89161234567',
                           :password => '123456',
                           :password_confirmation => '123456')
   
   admin_user.update(role: Role.with_name(:admin))

  #создание страницы главной
    Page.create(
        :id => '1',
        :title => 'Printely',
        :permalink => 'printely',
        :body => 'Добро пожаловать',
        :user_id => '1',
        :section_id => '0')
        
#создание тестовой категории статей
    Category.create(:name => "Тестовая категория")
    Category.create(:name => "Архив новостей")

    #создание страницы для описания всех услуг
    Page.create(
    :id => '2',
    :title => 'services',
    :permalink => 'services',
    :body => 'Эта страница с описанием всех услуг',
    :user_id => '1',
    :published => true)

#создание статусов заказа
    Lists::OrderStatus.create(:title => 'draft', :key => 10)
    Lists::OrderStatus.create(:title => 'на обработке', :key => 20)
    Lists::OrderStatus.create(:title => 'печатается', :key => 30)
    Lists::OrderStatus.create(:title => 'едет к Вам', :key => 40)
    Lists::OrderStatus.create(:title => 'выполнен', :key => 50)
    Lists::OrderStatus.create(:title => 'отклонен', :key => 51)
    
#типы бумаги
    Lists::PaperType.create(:paper_type => 'Глянцевая')
    Lists::PaperType.create(:paper_type => 'Матовая')
    Lists::PaperType.create(:paper_type => 'Сатин')
    
#размеры бумаги
    Lists::PaperSize.create(:size => '10x15', :size_iso_216 => 'A6')
    Lists::PaperSize.create(:size => '21x29,7', :size_iso_216 => 'A4')

#поля
    Lists::PrintMargin.create(:margin => 'С полями')
    Lists::PrintMargin.create(:margin => 'Без полей')
    
#классы бумаги
    Lists::PaperGrade.create(:grade => 'Стандарт')
    Lists::PaperGrade.create(:grade => 'Премиум')
    
#типы заказов
      Lists::OrderType.create(
          :id => '1',
          :title => 'all'
          )

      Lists::OrderType.create(
          :id => '2',
          :title => 'foto_print'
          )

      Lists::OrderType.create(
          :id => '3',
          :title => 'doc_print'
          )

      Lists::OrderType.create(
          :id => '4',
          :title => 'scan'
          )