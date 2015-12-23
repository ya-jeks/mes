class Sku < ActiveRecord::Base
  belongs_to :product
  belongs_to :uom

  has_many :sku_parts, dependent: :destroy
  has_many :sku_suppliers, dependent: :destroy
  has_many :presets, through: :product

  has_one :main_preset, through: :product, class_name: 'Preset'

  validates_presence_of :product, :uom
  validates_uniqueness_of :product, scope: :uom

  def price_on(supp)
    sku_suppliers.where(supplier: supp).try(:first).try(:price).to_f
  end
end
