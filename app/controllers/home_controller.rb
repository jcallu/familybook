class HomeController < ApplicationController
  def index
    redirect_to new_user_session_path unless user_signed_in?
    #else
    @post = Post.new
    followees_ids = current_user.followees(User)
    #get only the ids of the people current_user folllows
    followees_ids << current_user.id
    #@activities = PublicActivity::Activity.where(owner_id: followees_ids, owner_type: "User")
    #end
  end
end

