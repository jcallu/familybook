class AddFamilyIdToFamilyMemberships < ActiveRecord::Migration
  def change
    add_column :family_memberships, :family_id, :integer
  end
end
