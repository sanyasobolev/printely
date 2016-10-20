class AddSubsectionIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :subsection_id, :integer
  end
end
