class PlanTask < ActiveRecord::Base
  belongs_to :plan
  belongs_to :task
end
