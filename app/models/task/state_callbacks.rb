class Task
  module StateCallbacks

    def after_plan
      tasks.map{|t| t.plan! if t.plannable}
    end

    def after_finish
      deliver! if deliverable
    end

  end
end
