class UserMailer < ApplicationMailer
  default from: ENV['FROM_EMAIL_ADDRESS']

  def restore_password_email(user, recover_password_token)
    @recover_url = "#{ENV['SITE_BASE_URL'] || 'http://localhost:3001' }/recover-password?token=#{recover_password_token}"
    mail(to: user.email, subject: "Restore your password")
  end
end
