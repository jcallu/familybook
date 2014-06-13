class CreateUserDefaultFamilies < ActiveRecord::Migration
  def change
    create_table :user_default_families do |t|
      t.integer :user_id
      t.integer :family_id

      t.timestamps
    end
  end
end
