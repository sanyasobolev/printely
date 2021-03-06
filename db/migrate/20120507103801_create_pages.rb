# encoding: utf-8
class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title, :string
      t.column :permalink, :string
      t.column :body, :text
      t.column :published, :boolean, :default => false
      t.column :published_at, :datetime
      t.column :user_id, :integer
      t.column :section_id, :integer
      t.timestamps null: false
    end

  end

  def self.down
    drop_table :pages
  end
end
