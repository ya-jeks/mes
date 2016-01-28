class Task
  module StateHelpers

    def plannable
      [:initialized, :rejected].include?(state.to_sym)
    end

    def finishable
      planned? && children_delivered?
    end

    def deliverable
      finished? && parents.any?
    end

    def acceptable
      delivered?
    end

    def rejectable
      delivered?
    end

    def destroyable
      [:initialized, :rejected].include?(state.to_sym) && parents.empty?
    end

    def make_residuals
      if residuals.present? and residuals.first.src.parents.planned.empty? # generates residuals only if last item produced
        residuals.map(&:make_residual!)
      end
    end

  end
end
