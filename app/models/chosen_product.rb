class ChosenProduct < ActiveRecord::Base
  belongs_to :session
  belongs_to :product

  validate :variant_presence
  validates_presence_of :session, :product
  validates_uniqueness_of :product_id, scope: [:session_id, :tech_path], message: 'Can\'t set more than one variant for one part'

  scope :head, -> { where(tech_path: '')}
  scope :props, -> { where.not(tech_path: '')}

  scope :by_product, ->(product) { where(product: product) }
  scope :by_tech_path, ->(tech_path) { where(tech_path: tech_path) }

  def property
    @property ||= SkuPart.find_by_id(tech_path.scan(/\/(\d+)\:\d+\z/).flatten.first)
  end

  def variant_presence
    if property.present? and property.product_ids.exclude?(product.id)
      errors.add(:product_id, "Product must be present in part variants")
    end
  end
end
