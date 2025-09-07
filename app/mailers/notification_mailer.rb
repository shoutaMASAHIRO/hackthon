# app/mailers/notification_mailer.rb
class NotificationMailer < ApplicationMailer
  default from: Rails.application.credentials.dig(:gmail, :user_name)

  def like_created(post, liker)
    @post  = post
    @liker = liker
    mail(
      to:       @post.user.email,  # 投稿者
      reply_to: @liker.email,
      subject:  "#{@liker.email} さんがあなたの投稿にいいねしました"
    )
  end
end
