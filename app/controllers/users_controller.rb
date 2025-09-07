class UsersController < ApplicationController
  # 一覧/プロフィールはログインユーザーだけ見られる想定（外したいならこの行削除）
  before_action :authenticate_user!

  def index
    @q = params[:q].to_s.strip
    @users = User.order(created_at: :desc)
    @users = User.order(created_at: :desc).page(params[:page]).per(5)
    if @q.present?
      like = "%#{@q}%"
      @users = @users.where("users.name LIKE :q OR users.email LIKE :q", q: like)
    end
  end
  

  def show
    @user  = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
end
