class RegistrationMailer < ApplicationMailer

  def welcome(user, password)
    @email, @password = user.email, password
    mail(to: user.email, subject: "Password for service #{ENV['SERVICE_URL']}")
  end
end
