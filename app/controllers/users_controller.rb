class UsersController < ApplicationController
  before_action :set_user, only: [:show]
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
    @activities = PublicActivity::Activity.where(owner_id: @user.id, owner_type: "User")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def update
    @user.update_attribute(:avatar,user_params['id'])
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
    else
      @likeable = Comment.find(params[:likeable_id])
    end
  	current_user.like!(@likeable)
  end

  def unlike
    if params[:likeable_type] == "Post"
      @likeable = Post.find(params[:likeable_id])
    else
      @likeable = Comment.find(params[:likeable_id])
    end
	  current_user.unlike!(@likeable)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :remember_me, :avatar)
    end
end
