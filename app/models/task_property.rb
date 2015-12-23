class TaskProperty < ActiveRecord::Base
  belongs_to :task
  belongs_to :tech, foreign_key: :tech_path, primary_key: :tech_path
  belongs_to :product

  validates_presence_of :task, :tech_path, :product
  validates_uniqueness_of :tech_path, scope: [:task_id]

  def label
    @label ||= "#{(tech.try(:label) || property.try(:name))}: #{product.name}"
  end

  def property
    @property ||= SkuPart.find_by_id(tech_path.scan(/\/(\d+)\:\d+\z/).flatten.first)
  end

end
