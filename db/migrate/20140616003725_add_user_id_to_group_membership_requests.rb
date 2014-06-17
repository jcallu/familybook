class AddUserIdToGroupMembershipRequests < ActiveRecord::Migration
  def change
    add_column :group_membership_requests, :user_id, :integer
  end
end
