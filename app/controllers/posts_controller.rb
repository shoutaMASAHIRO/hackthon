class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]
  
  def index
    @q = params[:q].to_s.strip
    @posts = Post.includes(:user).order(created_at: :desc)
    @posts = Post.order(created_at: :desc).includes(:user).page(params[:page]).per(5)
    if @q.present?
      like = "%#{@q}%"
      @posts = @posts.where("posts.title LIKE :q OR posts.body LIKE :q", q: like)
    end
  end
  
  

  def show
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "投稿を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if params[:remove_image] == "1"
      @post.image.purge_later if @post.image.attached?
    end
    if @post.update(post_params)
      redirect_to @post, notice: "投稿を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_owner!
    redirect_to @post, alert: "権限がありません。" unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
