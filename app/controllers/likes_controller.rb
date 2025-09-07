class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  # app/controllers/likes_controller.rb
def create
  @post = Post.find(params[:post_id])
  current_user.likes.find_or_create_by!(post: @post)

  # いいね通知メール送信（非同期）
  NotificationMailer.like_created(@post, current_user).deliver_later

  redirect_to @post, notice: 'いいねしました'
end

  

  def destroy
    current_user.likes.where(post: @post).destroy_all

    respond_to do |f|
      f.html { redirect_to @post, notice: "いいねを取り消しました。" }
      f.js   # -> app/views/likes/destroy.js.erb
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
