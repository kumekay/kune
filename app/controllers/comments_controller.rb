class CommentsController < ApplicationController
  def create
    @comment_hash = comment_params

    #Check that comment parent is article or other comment
    if ['Comment', 'Article'].include?(@comment_hash[:commentable_type])
      @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    end
    
    @comment = Comment.build_from(@obj, current_user.try(:id), @comment_hash[:username], @comment_hash[:body])

    if @comment.save
      render :partial => "comments/comment", :locals => { :comment => @comment }, :layout => false, :status => :created
    else
      render js: "alert('#{t('comments.comment.couldnot_save')}');"
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    if current_user && current_user.admin? && @comment.destroy
      render :json => @comment, :status => :ok
    else
      render js: "alert('#{t('comments.comment.couldnot_delete')}');"
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:body, :commentable_type, :commentable_id, :username, :user)
  end
end