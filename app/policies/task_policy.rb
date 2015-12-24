class TaskPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user, @task = user, task
  end

  def show?
    Task.accessible_to_view_by(user).include? task
  end

  def destroy?
    task.destroyable
  end

  def plan?
    task.plannable and user.suppliers.include? task.supplier
  end

  def finish?
    task.finishable and user.suppliers.include? task.supplier
  end

  def deliver?
    task.deliverable and user.suppliers.include? task.supplier
  end

  def accept?
    false
  end

  def reject?
    false
  end
end
