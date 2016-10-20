class AddServiceIdAndSubserviceIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :service_id, :integer
    add_column :pages, :subservice_id, :integer
  end
end
