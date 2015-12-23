class TaskMailer < ApplicationMailer

  def notification(user, task)
    @task = task
    mail(to: user.email, subject: "Новый заказ для #{task.supplier.address}")
  end
end
