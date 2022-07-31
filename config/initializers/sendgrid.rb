if(Rails.env.production?)
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => 'apikey',
    :password       => Rails.application.credentials.dig(:sendgrid, :key),
    :domain         => 'crespire.dev'
  }
  ActionMailer::Base.delivery_method = :smtp
end