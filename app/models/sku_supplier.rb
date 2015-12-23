class SkuSupplier < ActiveRecord::Base
  belongs_to :sku
  belongs_to :supplier

  validates_presence_of :sku, :supplier, :duration

  validates_uniqueness_of :sku, scope: [:supplier], message: 'Товар уже поставляется'

end
