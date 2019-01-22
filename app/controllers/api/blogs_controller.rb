class Api::BlogsController < Api::ApiController

  authenticated! except: [:show, :index]

  before_action :find_blog, except: [:create, :show, :index]
  before_action :check_is_admin, except: [:show, :index]

  def index
    @blogs = Blog.all
    respond_with @blogs, status: 200
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    if @blog.save
      respond_with @blog, status: 201
    else
      render json: { error: 'unable to save blog because of : '+ @blog.errors.full_messages.to_sentence }
    end
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def update
    if @blog.update_attributes(blog_params)
      respond_with @blog, status: 200
    else
      render json: { error: 'unable to save blog because of : '+ @blog.errors.full_messages.to_sentence }
    end
  end

  def destroy
    if @blog.destroy
      render json: {message: "Blog deleted successfully", status: 200}
    else
      render json: {message: "Unable to delete Blog", status: 404}
    end
  end

  protected

  def find_blog
    @blog = current_user.blogs.find(params[:id])
  end

  def check_is_admin
    render json: {message: "Unauthorization for access blogs.", status: 401} unless current_user.is_admin
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :featured_image, :category, :slug, :meta_description)
  end

end
