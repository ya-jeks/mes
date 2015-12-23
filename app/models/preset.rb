class Preset < ActiveRecord::Base
  validates_presence_of :name

  has_many :product_presets, dependent: :destroy
  has_many :products, through: :product_presets

  has_many :preset_variants, dependent: :destroy
  has_many :variants, through: :preset_variants, source: :product
end
