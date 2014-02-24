class CommentsController < ApplicationController
  def create

    # Set object
    @article = Article.find(params[:article_id])
    @comment = Comment.build_from(@article, current_user.try(:id), comment_params[:username], comment_params[:body])

    # Set parent
    @comment.parent_id = comment_params[:parent_id]

    if @comment.save
      redirect_to @article, notice: t('comments.comment.successfully_saved')
    else
      redirect_to @article, error: t('comments.comment.couldnot_save')
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    if current_user.try(:admin?) && @comment.destroy
      render json: { id: @comment.id }, status: :ok
    else
      render js: "alert('#{t('comments.comment.couldnot_delete')}');", status: 500
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id, :parent_id, :username, :user)
  end
end