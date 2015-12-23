class Task
  module PriceHelpers

    def description
      task_properties.map{|pr| pr.label}.join(', ')
    end

    def total
      if task_properties.empty?
        price
      else
        price + task_properties.map(&:price).reduce(&:+)
      end
    end

    def subtasks_total
      tasks.map(&:total).reduce(&:+)
    end

  end
end