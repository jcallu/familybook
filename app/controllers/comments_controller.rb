class CommentsController < ApplicationController

  before_filter :authenticate_user!, only: [:create, :destroy]

  def create
    @post = Post.find(comments_params['post_id'])
    @comment = Comment.new(comments_params)
    @comment.user = current_user
    @comment.save
    redirect_to root_url
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
