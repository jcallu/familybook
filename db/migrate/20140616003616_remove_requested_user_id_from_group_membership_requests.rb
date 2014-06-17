class RemoveRequestedUserIdFromGroupMembershipRequests < ActiveRecord::Migration
  def change
    remove_column :group_membership_requests, :requested_user_id, :integer
  end
end
