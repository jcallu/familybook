class AddUserIdToGroupMemberships < ActiveRecord::Migration
  def change
    add_column :group_memberships, :user_id, :integer
  end
end
