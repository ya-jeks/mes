module TasksHelper

  STATE_COLORS = {
    initialized: 'default',
    future_residual: 'default',
    planned: 'warning',
    finished: 'success',
    delivered: 'info',
    accepted: 'info',
    rejected: 'danger',
    destroy: 'danger'
  }

  ACTION_COLORS = {
    'activerecord.actions.task.finish' => 'success',
    'activerecord.actions.task.deliver' => 'info',
    'activerecord.actions.task.accept' => 'info',
    'activerecord.actions.task.reject' => 'danger',
    'activerecord.actions.task.destroy' => 'danger'
  }

  ACTION_ICONS = {
    'activerecord.actions.task.plan' => 'fa fa-calendar-check-o',
    'activerecord.actions.task.finish' => 'fa fa-check',
    'activerecord.actions.task.deliver' => 'fa fa-truck',
    'activerecord.actions.task.accept' => 'fa fa-check',
    'activerecord.actions.task.reject' => 'fa fa-ban',
    'activerecord.actions.task.destroy' => 'fa fa-remove'
  }

  HUMAN_STATE= {
    initialized: 'Новый',
    future_residual: 'Буд.остаток',
    planned: 'В плане',
    finished: 'Готов',
    delivered: 'Отправлен',
    accepted: 'Принят',
    rejected: 'Возврат'
  }

  def task_color(task)
    STATE_COLORS[task.state.to_sym]
  end

  def human_task_state(task)
    HUMAN_STATE[task.state.to_sym]
  end

  def task_label_class(task)
    "label-#{task_color(task)}"
  end

  def task_is_wrapper(task)
    task.tasks.any?
  end

  def task_action_icon(act)
    ACTION_ICONS[act]
  end

  def task_action_color(act)
    ACTION_COLORS[act]
  end

  def task_actions(task)
    policy = TaskPolicy.new(current_user, task)
    actions = {}
    actions.merge!('activerecord.actions.task.finish' => finish_task_path(task)) if policy.finish?
    actions.merge!('activerecord.actions.task.deliver' => deliver_task_path(task)) if policy.deliver?
    actions.merge!('activerecord.actions.task.accept' => accept_task_path(task)) if policy.accept?
    actions.merge!('activerecord.actions.task.reject' => reject_task_path(task)) if policy.reject?
    actions
  end
end
