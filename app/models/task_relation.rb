class TaskRelation < ActiveRecord::Base
  belongs_to :task
  belongs_to :parent, class_name: 'Task'

  validate :supplier_sameness
  validates_presence_of :task, message: 'Task not set'
  validates_presence_of :parent, message: 'Parent not set'

  # TODO Why?
  # after_destroy do |tr|
  #   tr.task.destroy if tr.task.parents.empty?
  # end
  #
  
  def supplier_sameness
    if task.parents_suppliers.uniq.size > 1
      errors.add(:task, "Next tasks should be for the same supplier")
    end
  end
end
