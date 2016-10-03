class Task
  module ValidationHelpers

    def children_delivered?
      (tasks.order(:id) == tasks.delivered.order(:id)) ||
      (tasks.order(:id) == tasks.where(state: %w(delivered accepted)).order(:id)) # BUG with subtasks accepted by other parent task
    end

    def tasks_presence
      if tasks.empty?
        errors.add(:tasks, "No subtasks for complex product task")
      end
    end
  end
end
