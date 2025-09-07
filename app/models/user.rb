# app/models/user.rb
class User < ApplicationRecord
  # ← これを追加（必要なモジュールだけでOK）
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # フォローしている関係
  has_many :active_follows, class_name: "Follow",
                            foreign_key: :follower_id,
                            inverse_of: :follower,
                            dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  # フォローされている関係
  has_many :passive_follows, class_name: "Follow",
                             foreign_key: :followed_id,
                             inverse_of: :followed,
                             dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :posts,    dependent: :destroy
  has_many :comments, dependent: :destroy

  def follow(other_user)
    return if self == other_user
    active_follows.find_or_create_by!(followed: other_user)
  end

  def unfollow(other_user)
    active_follows.find_by(followed: other_user)&.destroy
  end

  def following?(other_user)
    following.exists?(other_user.id)
  end

  def liked?(post)
    likes.exists?(post_id: post.id)
  end
end
