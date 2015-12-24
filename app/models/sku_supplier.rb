class SkuSupplier < ActiveRecord::Base
  belongs_to :sku
  belongs_to :supplier

  validates_presence_of :sku, :supplier, :duration, :price
  validates_uniqueness_of :sku, scope: [:supplier]

end
