class CommentsController < ApplicationController

  before_filter :authenticate_user!, only: [:create, :destroy]

  include GroupHelper

  def create
    @post = Post.find(comments_params['post_id'])
    unless comments_params['content'].blank?
      @comment = Comment.new(comments_params)
      @comment.user = current_user
      @comment.save
      @activity = PublicActivity::Activity.find(PublicActivity::Activity.where(:trackable_id => @comment.id, :trackable_type => 'Comment').first.id)
      @activity.group_id = current_group.id
      @activity.save
      redirect_to root_url
    else
      respond_to do |format|
        format.html{ redirect_to @post, notice: 'Your comment was blank, please try again.'}
        #format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @posts = Post.all
    @post = Post.find(comments_params['post_id'])
  end
  private
    def comments_params
      params.require(:comment).permit(:content, :post_id)
    end
end
