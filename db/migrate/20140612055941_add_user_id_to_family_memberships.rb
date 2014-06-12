class AddUserIdToFamilyMemberships < ActiveRecord::Migration
  def change
    add_column :family_memberships, :user_id, :integer
  end
end
