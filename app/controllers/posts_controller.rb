class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comment = Comment.new
    @comments = @post.comments

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    respond_to do |format|
      if @post.save
        @post.avatar_url_thumb = @post.avatar.url(:thumb)
        @post.avatar_url_original = @post.avatar.url(:original)
        @post.save
        format.html { redirect_to root_url, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    post_id = @post.id
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
    @post_activites = PublicActivity::Activity.where("trackable_type = 'Post' AND trackable_id = #{post_id}").pluck(:id).drop(1)
    PublicActivity::Activity.destroy(@post_activites)
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    post_id = @post.id
    @post.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Post was successfully Deleted.' }
      format.json { head :no_content }
    end

    # Destroy .create and .destroy post activity
    @post_activites = PublicActivity::Activity.where("trackable_type = 'Post' AND trackable_id = #{post_id}").pluck(:id)
    PublicActivity::Activity.destroy(@post_activites)

    # Destroy Post's Comments and their Activity Feed
    @comments = Comment.where("post_id = #{post_id} ").pluck(:id)
    unless @comments.empty?
      Comment.destroy(@comments)

      # Destroy .destroy comment activity
      @comment_activities = PublicActivity::Activity.where("trackable_type = 'Comment' AND trackable_id IN (#{@comments.to_s.gsub("[","").gsub("]","")} )").pluck(:id)
      PublicActivity::Activity.destroy(@comment_activities)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit( :user_id, :content, :avatar)
    end
end
