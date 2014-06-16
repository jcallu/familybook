class RemoveRequestedUserIdFromFamilyMembershipRequests < ActiveRecord::Migration
  def change
    remove_column :family_membership_requests, :requested_user_id, :integer
  end
end
