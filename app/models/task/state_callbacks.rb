class Task
  module StateCallbacks

    def after_plan
      tasks.map{|t| t.plan! if t.plannable}
    end

    def after_finish
      make_residuals
      deliver! if deliverable
      tasks.map{|t| t.accept! if t.acceptable } # BUG if acceptable
    end

  end
end
