# encoding: utf-8
class AddPermalinkToSections < ActiveRecord::Migration
  def change
     add_column :sections, :permalink, :string

    Section.create(
      :id => '1',
      :title => 'статьи',
      :order => '1',
      :controller => 'articles',
      :action => 'index',
      :permalink => 'statyi'
    )

    Section.create(
      :id => '2',
      :title => 'услуги',
      :order => '2',
      :controller => 'services',
      :action => 'index',
      :permalink => 'uslugi'
    )
  end
end
