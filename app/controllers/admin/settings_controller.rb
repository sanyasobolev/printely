# encoding: utf-8
class Admin::SettingsController < ApplicationController
  before_filter :login_required
  before_action :role_required
  
  def index
    @title = 'Администрирование системы'
  end
end
