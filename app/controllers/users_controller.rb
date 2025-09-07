class UsersController < ApplicationController
  # 一覧/プロフィールはログインユーザーだけ見られる想定（外したいならこの行削除）
  before_action :authenticate_user!

  def index
    @q = params[:q].to_s.strip
  
    # ベースクエリ（includesでN+1を防ぎつつorder）
    @users = User
               .includes(:posts, :comments, :likes, :passive_follows, :active_follows)
               .order(created_at: :desc)   # 新しい順なら :desc、ID順なら :id
  
    # 検索がある場合は条件を追加
    if @q.present?
      like = "%#{@q}%"
      @users = @users.where("users.name LIKE :q OR users.email LIKE :q", q: like)
    end
  
    # ページネーションは最後にチェインする
    @users = @users.page(params[:page]).per(5)
  end
  
  
  def show
    @user  = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following.includes(:active_follows).order(:id)
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.includes(:passive_follows).order(:id)
  end
end
