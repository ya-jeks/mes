class Report
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date, @end_date = start_date, end_date
  end

  def lines
    [
      {
        label: 'Оплачено',
        value: Task.accepted.top.between_dates(start_date, end_date).map(&:total).reduce(&:+)
      },
      {
        label: 'Отгружено',
        value: Task.delivered.top.between_dates(start_date, end_date).map(&:total).reduce(&:+)
      },
      {
        label: 'Готово на складе',
        value: Task.finished.top.between_dates(start_date, end_date).map(&:total).reduce(&:+)
      },
      {
        label: 'Запланировано',
        value: Task.planned.top.between_dates(start_date, end_date).map(&:total).reduce(&:+)
      },
      {
        label: 'Закупки',
        value: Task.ransack(tasks_id_null: true).result.uniq.where(state: %w(finished delivered accepted)).between_dates(start_date, end_date).map(&:total).reduce(&:+)
      },
      {
        label: 'Зарплата',
        value: Task.ransack(tasks_id_and_parents_id_null: false).result.uniq.where(state: %w(finished delivered accepted)).between_dates(start_date, end_date).map(&:total).reduce(&:+)
      }
    ]
  end
end
