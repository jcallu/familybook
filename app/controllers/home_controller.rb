class HomeController < ApplicationController

  include GroupHelper

  def index
    unless user_signed_in?
      redirect_to new_user_session_path
    else
      dbx = DropboxUrl.results
      # Reload and updated new links for expired user images from dropbox
      users = User.where("avatar_file_name IS NOT NULL")
      if users.any?
        unless dbx.url_exists?(users.last.avatar_url_thumb)      
          users.each do |user|
            user.avatar_url_thumb = user.avatar.url(:thumb)
            user.avatar_url_original = user.avatar.url(:original)
            user.save
          end
        end
      end
      # Reload and updated new links for expired posts images from dropbox
      posts_with_pics = Post.where("avatar_file_name IS NOT NULL")
      if posts_with_pics.any?
        unless dbx.url_exists?(posts_with_pics.last.avatar_url_thumb)      
          posts_with_pics.each do |post|
            post.avatar_url_thumb = post.avatar.url(:thumb)
            post.avatar_url_original = post.avatar.url(:original)
            post.save
            @post_activities = PublicActivity::Activity.where("trackable_type = 'Post' AND trackable_id = #{post.id}").pluck(:id).sort!.reverse.drop(1).reverse
            PublicActivity::Activity.destroy(@post_activities)
            @activity = PublicActivity::Activity.find(PublicActivity::Activity.where(:trackable_id => post.id, :trackable_type => 'Post', :key => 'post.update').first.id)
            @activity.group_id = current_group.id
            @activity.save
          end
        end
      end
      @post = Post.new
      followees_ids = current_user.followees(User).map{|r| r.id}
      followees_ids << current_user.id

      news_feed_query = "SELECT activity.* FROM activities activity LEFT JOIN ( SELECT act.post_id, MAX (act.id) AS ID FROM ( SELECT CASE WHEN a1. KEY LIKE 'post%' THEN p1.posts_id WHEN a1. KEY LIKE 'comment%' THEN c1.post_id WHEN a1. KEY LIKE 'like%' THEN l1.post_id END AS post_id, a1.id FROM activities a1 LEFT JOIN (SELECT ID AS posts_id FROM posts) p1 ON p1.posts_id = a1.trackable_id AND a1. KEY LIKE 'post%' LEFT JOIN ( SELECT MAX (ID) AS trackable_id2, post_id FROM comments GROUP BY post_id ) c1 ON c1.trackable_id2 = a1.trackable_id AND a1. KEY LIKE 'comment%' LEFT JOIN ( SELECT MAX (likes.id) AS trackable_id3, CASE WHEN c1.post_id IS NULL THEN likeable_id ELSE c1.post_id END AS post_id FROM likes LEFT JOIN comments c1 ON c1.id = likeable_id AND likeable_type = 'Comment' GROUP BY 2 ) l1 ON l1.trackable_id3 = a1.trackable_id AND a1. KEY LIKE 'like%' WHERE p1.posts_id IS NOT NULL OR c1.post_id IS NOT NULL OR l1.post_id IS NOT NULL ORDER BY 1 DESC, 2 DESC ) act GROUP BY 1 ) act2 ON act2.id = activity.id WHERE act2.id IS NOT NULL ORDER BY created_at DESC"

      new_feed_activities = PublicActivity::Activity.find_by_sql(news_feed_query).map {|r| r.id}
      
      group_id = params[:group] || (current_group.id unless current_group.nil?)

      @activities = PublicActivity::Activity.where(id: new_feed_activities, owner_id: followees_ids , owner_type: "User", group_id: group_id)
    end
  end
end

