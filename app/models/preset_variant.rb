class PresetVariant < ActiveRecord::Base
  belongs_to :preset
  belongs_to :product

  validates_presence_of :preset, :tech_path, :product
end
