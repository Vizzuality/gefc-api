class UsermailerMailer < ApplicationMailer
  default from: 'ibrahim.lachguer@vizzuality.com'

  def restore_password_email(user, recover_password_token)
    @user = user
    @recover_url = "https://green-energy-data-platform.vercel.app/recover-password?token=#{recover_password_token}"
    @url = 'http://www.gmail.com'
    mail(to: user.email, subject: 'Restore your password')
  end
end
