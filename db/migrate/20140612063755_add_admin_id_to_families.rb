class AddAdminIdToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :admin_id, :integer
  end
end
