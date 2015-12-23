class Product < ActiveRecord::Base
  has_many :product_presets, dependent: :destroy
  has_many :presets, through: :product_presets

  has_many :skus
  has_many :variant_prices
  has_many :images, as: :imageable

  validates :name, presence: true, uniqueness: true

end
