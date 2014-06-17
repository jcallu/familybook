class AddGroupIdToGroupMemberships < ActiveRecord::Migration
  def change
    add_column :group_memberships, :group_id, :integer
  end
end
