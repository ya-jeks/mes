class PartProduct < ActiveRecord::Base
  belongs_to :part
  belongs_to :product

  validates_presence_of :product
  validates_presence_of :part

  validates_uniqueness_of :product, scope: :part
end
