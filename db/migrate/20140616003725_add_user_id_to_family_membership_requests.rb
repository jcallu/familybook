class AddUserIdToFamilyMembershipRequests < ActiveRecord::Migration
  def change
    add_column :family_membership_requests, :user_id, :integer
  end
end
