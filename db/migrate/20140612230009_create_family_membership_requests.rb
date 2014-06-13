class CreateFamilyMembershipRequests < ActiveRecord::Migration
  def change
    create_table :family_membership_requests do |t|
      t.integer :requested_user_id
      t.integer :family_id

      t.timestamps
    end
  end
end
