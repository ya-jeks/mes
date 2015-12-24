class TaskMailer < ApplicationMailer

  def notification(user, task)
    @task = task
    mail(to: user.email, subject: "New task for #{task.supplier.address}")
  end
end
