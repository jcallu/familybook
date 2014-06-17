class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|

      t.timestamps
    end
  end
end
