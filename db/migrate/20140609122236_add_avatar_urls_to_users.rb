class AddAvatarUrlsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_url_thumb, :string
    add_column :users, :avatar_url_original, :string
  end
end
