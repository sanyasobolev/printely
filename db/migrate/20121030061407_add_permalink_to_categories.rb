class AddPermalinkToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :permalink, :string
    testovay_categoriya = Category.find_by_id('1')
    testovay_categoriya.update_attributes(:permalink => 'testovaya-categoriya')
  end
end
