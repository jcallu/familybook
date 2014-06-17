class AddFamilyIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :family_id, :integer
  end
end
