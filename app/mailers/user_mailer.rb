class UserMailer < ApplicationMailer
  default from: 'notifications@petbook.crespire.dev'

  def welcome_email
    @user = params[:user]
    @url = 'http://petbook.crespire.dev/users/sign_in'
    mail(to: @user.email, subject: "Welcome to Petbook!")
  end
end
