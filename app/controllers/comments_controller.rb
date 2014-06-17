class CommentsController < ApplicationController
  respond_to :html, only: [:create, :edit, :update, :destroy]
  inherit_resources
  authorize_resource

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    create! { article_path(@comment.article_id) }
  end

  def comment_params
    params.require(:comment).permit(:body, :article_id)
  end
end