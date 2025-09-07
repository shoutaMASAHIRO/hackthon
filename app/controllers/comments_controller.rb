class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      # 投稿主へ通知（自分自身には送らない）
      if @post.user_id != current_user.id && @post.user.email.present?
        NotificationMailer.comment_created(@post, @comment).deliver_later
      end
  
      redirect_to @post, notice: "コメントを投稿しました。"
    else
      render "posts/show", status: :unprocessable_entity
    end
  end
  

  def edit
    # render :edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @post, notice: "コメントを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: "コメントを削除しました。"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  # 自分のコメントのみ編集/削除OK（投稿者にも権限を持たせたいなら条件を追加）
  def authorize_owner!
    allowed = (@comment.user == current_user)
    # 投稿者も編集できるようにしたい場合は ↓ を有効化
    # allowed ||= (@post.user == current_user)
    redirect_to @post, alert: "権限がありません。" unless allowed
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
