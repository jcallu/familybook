class UsersController < ApplicationController

  before_filter :authenticate_user!

  include FamilyHelper
  before_action :set_user, only: [:show, :edit, :update]
  # GET /users
  # GET /users.json
  def index
    unless user_signed_in?
      redirect_to new_user_session_path
    else
      @family_id = UserDefaultFamily.find_by_user_id(current_user.id)
      @family_id = @family_id.family_id unless @family_id.nil?
      #@users = User.all
      @users = User.joins("Left Join (select user_id, family_id From family_memberships) fm ON fm.user_id = users.id").where("fm.family_id = ?", @family_id)
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    unless @user.nil?
      followees_ids = current_user.followees(User).map{|r| r.id }
      followees_ids << current_user.id
      @user_id = @user.id if followees_ids.include?(@user.id)
      
      family_id = params[:family] || (current_family.id unless current_family.nil?)      

      @activities = PublicActivity::Activity.where(owner_id: @user_id, owner_type: "User", trackable_type: "Post", family_id: family_id)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
      @user
    end

  end

  def edit
  end

  def update
  end

  def follow
    @user = User.find(params[:user])
	  current_user.follow!(@user)
  end

  def unfollow
    @user = User.find(params[:user])
	  current_user.unfollow!(@user)
  end

  def like
    if params[:likeable_type] == "Post"
      @likeable = Post.find(params[:likeable_id])
      current_user.like!(@likeable)
      @trackable_id_from_likes = Like.where(:liker_id => current_user.id, :likeable_type => 'Post', :likeable_id => @likeable.id).first
    elsif params[:likeable_type] == "Comment"
      @likeable = Comment.find(params[:likeable_id])
      current_user.like!(@likeable)
      @trackable_id_from_likes = Like.where(:liker_id => current_user.id, :likeable_type => 'Comment', :likeable_id => @likeable.id).first
    end
    @activity = PublicActivity::Activity.find(PublicActivity::Activity.where("trackable_id = #{@trackable_id_from_likes.id} AND  key LIKE 'like%'").first.id)
    @activity.family_id = current_family.id
    @activity.save
  end

  def unlike
    if params[:likeable_type] == "Post"
      @likeable = Post.find(params[:likeable_id])
      current_user.unlike!(@likeable)

      # Clear deleted like activities and its parent creation
      PublicActivity::Activity.destroy(PublicActivity::Activity.find_by_sql("SELECT act.* FROM activities act LEFT JOIN likes l1 ON l1.\"id\" = act.trackable_id AND act.\"key\" LIKE 'like%' WHERE act.\"key\" LIKE 'like%' AND l1.\"id\" IS NULL").map {|r| r.id})

    elsif params[:likeable_type] == "Comment"
      @likeable = Comment.find(params[:likeable_id])
      current_user.unlike!(@likeable)
      PublicActivity::Activity.destroy(PublicActivity::Activity.find_by_sql("SELECT act.* FROM activities act LEFT JOIN likes l1 ON l1.\"id\" = act.trackable_id AND act.\"key\" LIKE 'like%' WHERE act.\"key\" LIKE 'like%' AND l1.\"id\" IS NULL").map {|r| r.id})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      family_members = family_members(current_family)
      if !family_members.nil? && family_members.map{|r| r.id}.include?(params[:id].to_i) || current_user.id==params[:id].to_i
        @user = User.find(params[:id]) 
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :avatar, :avatar_url, :family_id)
    end
end
