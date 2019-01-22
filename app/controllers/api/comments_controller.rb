class Api::CommentsController < Api::ApiController

  authenticated!

  before_action :find_comment, except: :create

  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      respond_with @comment, status: 201
    else
      render json: { error: 'unable to save comment because of : '+ @comment.errors.full_messages.to_sentence }
    end
  end

  def update
    if @comment.update_attributes(comment_params)
      respond_with @comment, status: 200
    else
      render json: { error: 'unable to save comment because of : '+ @comment.errors.full_messages.to_sentence }
    end
  end

  def show
  end

  def destroy
    if @comment.destroy
      render json: {message: "Comment deleted successfully", status: 200}
    else
      render json: {message: "Unable to delete Comment", status: 404}
    end
  end

  protected

  def find_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :blog_id, :parent_id)
  end

end
