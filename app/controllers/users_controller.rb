class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    followees_ids = current_user.followees(User).map{|r| r.id }
    followees_ids << current_user.id
    @user_id = @user.id if followees_ids.include?(@user.id)
    @activities = PublicActivity::Activity.where(owner_id: @user_id, owner_type: "User", trackable_type: "Post")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def edit
  end

  def update
    #@user.update_attributes(:avatar,user_params['id'])
    #@user.update_attribute(:name,user_params['id'])
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

    elsif params[:likeable_type] == "Comment"
      @likeable = Comment.find(params[:likeable_id])
  	  current_user.like!(@likeable)
    end
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
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :avatar, :avatar_url, :family_id)
    end
end
