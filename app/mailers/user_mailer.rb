class UserMailer < ApplicationMailer
  default from: 'hello@crespire.dev'

  def welcome_email
    @user = params[:user]
    @url = 'http://railsbook.crespire.dev/users/sign_in'
    mail(to: @user.email, subject: "Welcome to Railsbook!")
  end
end
