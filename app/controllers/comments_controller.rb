class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    @labelable = get_labelable(params)
    comment = @labelable.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      flash[:notice] = "Comment saved successfully."
    else
      flash[:alert] = "Comment failed to save."
    end
    handle_redirect(@labelable)
  end

  def destroy
    @labelable = get_labelable(params)
    comment = @labelable.comments.find(params[:id])

    if comment.destroy
      flash[:notice] = "Comment was deleted successfully."
    else
      flash[:alert] = "Comment could not be deleted. Try again."
    end
    handle_redirect(@labelable)
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You do not have permissions to delete the comment."
      handle_redirect(comment.labelable)
    end
  end

  def get_labelable(params)
    params[:post_id]? Post.find(params[:post_id]) : Topic.find(params[:topic_id])
  end

  def handle_redirect(labelable)
    if labelable.is_a? Topic
      redirect_to [labelable]
    else
      redirect_to [labelable.topic, labelable]
    end
  end
end
