class Part < ActiveRecord::Base
  has_many :part_products, dependent: :destroy
  has_many :products, -> { readonly }, through: :part_products

  validates :name, presence: true, uniqueness: true
  validates_presence_of :part_products
end
