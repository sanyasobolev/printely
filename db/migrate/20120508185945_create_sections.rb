# encoding: utf-8
class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.column :title, :string
      t.column :order, :integer
      t.column :controller, :string, :default => 'no'
      t.column :action, :string, :default => 'no'
      t.timestamps
    end

    Section.create(
      :id => '1',
      :title => 'Статьи',
      :order => '1',
      :controller => 'articles',
      :action => 'index'
    )

    Section.create(
      :id => '2',
      :title => 'Предложения',
      :order => '2',
      :controller => 'offers',
      :action => 'index'
    )
  end

  def self.down
    drop_table :sections
  end
end
