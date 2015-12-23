class Product < ActiveRecord::Base
  has_many :product_presets, dependent: :destroy
  has_many :presets, through: :product_presets

  has_one :main_product_preset, -> { where(main: true)}, class_name: 'ProductPreset'
  has_one :main_preset, through: :main_product_preset, source: :preset

  has_many :skus
  has_many :variant_prices

  validates :name, presence: true, uniqueness: true

end
