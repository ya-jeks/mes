class TaskSrc < ActiveRecord::Base
  belongs_to :task
  belongs_to :src, class_name: 'Task'
end
