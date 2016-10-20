class CreateMailings < ActiveRecord::Migration
  def change
    create_table :mailings do |t|
      t.string :subject
      t.text :body
      t.integer :sent_mails, :default => 0
      t.integer :all_mails, :default => 0
      t.boolean :published, :default => false
      t.datetime :published_at
      t.timestamps null: false
    end
  end
end
