class CreateSubsections < ActiveRecord::Migration
  def change
    create_table :subsections do |t|
      t.column :title, :string
      t.column :order, :integer
      t.column :controller, :string, :default => 'no'
      t.column :action, :string, :default => 'no'
      t.column :published, :boolean, :default => false
      t.column :permalink, :string
      t.column :section_id, :integer
      t.timestamps
    end
  end
end
