class HomeController < ApplicationController
  def index
    unless user_signed_in?
      redirect_to new_user_session_path 
    else
    @post = Post.new
    followees_ids = current_user.followees(User)
    #get only the ids of the people current_user folllows
    followees_ids << current_user.id
    @activities = PublicActivity::Activity.where(owner_id: followees_ids, owner_type: "User")
    end
  end
  
  def debug
    @post_id = 16
    @post = Post.find(@post_id)
    @comments = Comment.where("post_id == #{@post_id} ")
    @comment_activities = PublicActivity::Activity.where("key == 'comment.create' AND trackable_id IN #{@comments.pluck(:id).to_s.gsub("[","(").gsub("]",")") }")
    PublicActivity::Activity.destroy(@comment_activities.pluck(:id))
  end
end

