class SkuPart < ActiveRecord::Base
  belongs_to :sku
  belongs_to :part
  belongs_to :uom

  has_one :product, through: :sku
  has_many :products, through: :part

  validates_presence_of :sku, :part, :qty, :uom

  before_save :set_name

  def set_name
    self.name = "#{product.name}/#{part.name}" if name.blank?
  end

end
