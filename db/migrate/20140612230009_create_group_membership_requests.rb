class CreateGroupMembershipRequests < ActiveRecord::Migration
  def change
    create_table :group_membership_requests do |t|
      t.integer :requested_user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
