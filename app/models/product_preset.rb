class ProductPreset < ActiveRecord::Base
  belongs_to :preset
  belongs_to :product

  validates_uniqueness_of :product, scope: [:preset, :main], allow_nil: true
end
