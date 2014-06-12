class CreateFamilyMemberships < ActiveRecord::Migration
  def change
    create_table :family_memberships do |t|

      t.timestamps
    end
  end
end
