class RegistrationMailer < ApplicationMailer

  def welcome(user, password)
    @email, @password = user.email, password
    mail(to: user.email, subject: "Пароль")
  end
end
