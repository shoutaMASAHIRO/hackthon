class ApplicationMailer < ActionMailer::Base
  # Gmail のアドレスを送信元に統一
  default from: Rails.application.credentials.dig(:gmail, :user_name)
  layout 'mailer'
end
