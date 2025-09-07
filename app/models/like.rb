# app/models/like.rb
class Like < ApplicationRecord
  belongs_to :user   # いいねした人（= liker）
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit :notify_post_owner

  private
  def notify_post_owner
    return if post.user_id == user_id # 自分の投稿に自分でいいね→通知しない
    NotificationMailer.like_created(post, user).deliver_later
  end
end
