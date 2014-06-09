class AddAvatarUrlsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :avatar_url_thumb, :string
    add_column :posts, :avatar_url_original, :string
  end
end
