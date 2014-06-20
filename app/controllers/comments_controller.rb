class CommentsController < ApplicationController
  respond_to :html, only: [:create, :edit, :update, :destroy]
  inherit_resources
  belongs_to :article
  authorize_resource

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    create! do |format|
      @comment.errors.each do |field, msg|
        flash[:error] ||= ''
        flash[:error] += "#{Comment.model_name.human} #{msg} "
      end
      format.html { redirect_to parent_url }
    end
  end

  def destroy
    destroy! { parent_url }
  end

  def comment_params
    params.require(:comment).permit(:body, :article_id)
  end
end