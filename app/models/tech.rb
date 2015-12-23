class Tech < ActiveRecord::Base
  validates_presence_of :tech_path, :label
end
