class Task
  module StateCallbacks

    def after_plan
      tasks.map{|t| t.plan! if t.plannable}
    end

    def after_finish
      deliver! if deliverable
    end

    def after_deliver
      #tasks.map(&:accept!) #auto accept source if parent done
    end

    # def plan_parents
    #   if neighbors.map(&:nstate).min >= nstate
    #     parents.map{|t| t.plan! if TaskPolicy.new(user, t).plan? && t.state!='planned'}
    #   end
    # end
  end
end

