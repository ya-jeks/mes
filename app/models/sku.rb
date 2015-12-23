class Sku < ActiveRecord::Base
  belongs_to :product
  belongs_to :uom

  has_one :min_price

  has_many :sku_parts, dependent: :destroy
  has_many :sku_suppliers, dependent: :destroy

  validates_presence_of :product, :uom
  validates_uniqueness_of :product, scope: :uom
end