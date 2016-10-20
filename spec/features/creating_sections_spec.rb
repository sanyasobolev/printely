require 'spec_helper'
require 'rails_helper'

feature 'login as admin' do
  before do
    User.find(:email => )
  end
  scenario 'login in with right credentials' do
    visit '/login'
      fill_in 'user_email', with: 'info@printely.ru'
      fill_in 'user_password', with: '123456'
    click_button 'Войти'
    
    session = Capybara::Session.new
    
    expect(page).to have_content('Администрирование') 
  end
  
  scenario 'can create a section' do
    visit '/admin/sections'
    expect(page).to have_content('Разделы') 
    #find_by_id(25)

    fill_in 'section_title', with: 'Test Section'
    fill_in 'section_position', with: '1'
    
    click_button 'Сохранить'
    
    expect(page).to have_content('Элемент сохранен.')    
  end
end