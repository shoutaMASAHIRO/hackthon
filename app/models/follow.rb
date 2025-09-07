# app/models/follow.rb
class Follow < ApplicationRecord
    belongs_to :follower, class_name: "User"   # , counter_cache: :following_count を削除
    belongs_to :followed, class_name: "User"   # , counter_cache: :followers_count を削除
  
    validates :follower_id, uniqueness: { scope: :followed_id }
    validate  :not_self
  
    after_commit :notify_followed_by_email, on: :create
  
    private
    def not_self
      errors.add(:followed_id, "自分はフォローできません") if follower_id == followed_id
    end
  
    def notify_followed_by_email
      FollowMailer.followed_notification(id).deliver_later
    end
  end
  