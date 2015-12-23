class Task
  module ValidationHelpers

    def children_delivered?
      tasks.order(:id) == tasks.delivered.order(:id)
    end

    def tasks_presence
      if tasks.empty?
        errors.add(:tasks, "No subtasks for complex product task")
      end
    end
  end
end