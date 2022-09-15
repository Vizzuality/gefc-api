class UserMailer < ApplicationMailer
  def restore_password_email(user, recover_password_token)
    receiver = user.email
    sender = ENV['FROM_EMAIL_ADDRESS']
    subject = "Restore your password"

    html_body = render_to_string(
      :partial => 'user_mailer/restore_password_email.html.erb',
      :layout => false,
      :locals => { :recover_url => "#{ENV['SITE_BASE_URL'] || 'http://localhost:3001' }/recover-password?token=#{recover_password_token}" }
    )

    # send email
    send_email(receiver, sender, subject, html_body)
  end

  def send_email(receiver, sender, subject, html_body)
    encoding = "UTF-8"
    ses = Aws::SES::Client.new(
      region: Rails.application.credentials.aws_region,
      access_key_id: Rails.application.credentials.aws_access_key_id,
      secret_access_key: Rails.application.credentials.aws_secret_access_key
    )

    begin
      ses.send_email(
        {
          destination: {
            to_addresses: [
              receiver,
            ],
          },
          message: {
            body: {
              html: {
                charset: encoding,
                data: html_body,
              }
            },
            subject: {
              charset: encoding,
              data: subject,
            },
          },
          source: sender,
        }
      )
      puts "Email sent!"
    rescue Aws::SES::Errors::ServiceError => error
      puts "Email not sent. Error message: #{error}"
    end
  end

end
