class FollowMailer < ApplicationMailer
    def followed_notification(follow_id)
      @follow   = Follow.find(follow_id)
      @follower = @follow.follower   # フォローした人
      @followed = @follow.followed   # フォローされた人（使いたければ表示用に使う）
  
      subject = "[Hobbyverse] #{@follower.name.presence || @follower.email} さんが #{@followed.name.presence || @followed.email} さんをフォローしました"
  
      # 宛先を固定
      mail(to: "L1116shota@gmail.com", subject: subject)
    end
  end
  