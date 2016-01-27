class ResidualRelation < ActiveRecord::Base
  belongs_to :task
  belongs_to :residual, class_name: 'Task'

  validates_presence_of :task, message: 'Task for residual not set'
  validates_presence_of :residual, message: 'Residual not set'

end
