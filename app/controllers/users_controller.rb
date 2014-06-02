class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follow, :unfollow]
  around_action :set_likeable_type, only: [:like, :unlike]
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
    @user.update_attribute(:avatar,user_params.id)
  end

  def follow
    @user = User.find(user_params)
	  current_user.follow!(@user)
  end

  def unfollow
    @user = User.find(user_params)
	  current_user.unfollow!(@user)
  end

  def like
    @likeable_type == "Post" ? find_post_likeable_id : find_comment_likeable_id
    current_user.like!(@likeable_id)
  end

  def unlike
    @likeable_type == "Post" ? find_post_likeable_id : find_comment_likeable_id
    current_user.unlike!(@likeable_id)
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

    def set_likeable_type
      @likeable_type = params[:likeable_type]
    end

    def find_post_likeable_id
      @likeable_id = Post.find(params[:likeable_id])
    end

    def find_comment_likeable_id
      @likeable_id = Comment.find(params[:likeable_id])
    end
end