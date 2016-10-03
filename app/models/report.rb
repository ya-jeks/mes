class Report

  def lines
    [
      {
        label: 'Отгружено, оплачено',
        value: Task.accepted.top.where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      },
      {
        label: 'Отгружено, не оплачено',
        value: Task.delivered.top.where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      },
      {
        label: 'Готово на складе',
        value: Task.finished.top.where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      },
      {
        label: 'Запланировано',
        value: Task.planned.top.where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      },
      {
        label: 'Закупки',
        value: Task.ransack(tasks_id_null: true).result.uniq.where(state: %w(finished delivered accepted)).where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      },
      {
        label: 'Зарплата',
        value: Task.ransack(tasks_id_and_parents_id_null: false).result.uniq.where(state: %w(finished delivered accepted)).where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      },
      {
        label: 'Зарплата',
        value: Task.ransack(tasks_id_and_parents_id_null: false).result.uniq.where(state: %w(finished delivered accepted)).where('tasks.updated_at > ?', Date.today.beginning_of_week).map(&:total).reduce(&:+)
      }
    ]
  end
end
