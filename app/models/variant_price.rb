class VariantPrice < ActiveRecord::Base
  belongs_to :product
  belongs_to :variant, class_name: 'Product'

  validates_presence_of :product, :tech_path, :variant, :price
  validates_uniqueness_of :variant, scope: [:product, :tech_path]
end
