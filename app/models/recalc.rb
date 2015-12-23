class Recalc < ActiveRecord::Base
  belongs_to :sku
  belongs_to :uom

  validates_presence_of :qty
end
