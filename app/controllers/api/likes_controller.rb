class Api::LikesController < Api::ApiController

  authenticated!

  before_action :find_like, except: :create

  def create
    @like = current_user.likes.new(like_params)
    if @like.save
      respond_with @like, status: 201
    else
      render json: { error: 'unable to save like because of : '+ @like.errors.full_messages.to_sentence }
    end
  end

  def update
    if @like.update_attributes(like_params)
      respond_with @like, status: 200
    else
      render json: { error: 'unable to save like because of : '+ @like.errors.full_messages.to_sentence }
    end
  end

  def show
  end

  def destroy
    if @like.destroy
      render json: {message: "Like deleted successfully", status: 200}
    else
      render json: {message: "Unable to delete Like", status: 404}
    end
  end

  protected

  def find_like
    @like = current_user.likes.find(params[:id])
  end

  def like_params
    params.require(:like).permit(:likable_id, :likable_type)
  end

end
