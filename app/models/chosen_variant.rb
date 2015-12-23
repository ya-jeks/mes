class ChosenVariant < ActiveRecord::Base
  belongs_to :session
  belongs_to :product

  validate :variant_presence
  validates_presence_of :session, :product
  validates_uniqueness_of :product_id, scope: [:session_id, :tech_path], message: 'Can\'t set more than one variant for one part'

  scope :head, -> { where(tech_path: '')}
  scope :by_session, ->(session) { where(session: session) }
  scope :by_product, ->(product) { where(product: product) }
  scope :by_tech_path, ->(tech_path) { where(tech_path: tech_path) }

  def self.set_head_for_session!(session_record, product)
    set_for_session!(session_record, product, '')
  end

  def self.set_preset_for_session!(session, preset)
    by_session(session).where.not(tech_path: '').delete_all
    preset.preset_variants.map do |pr|
      set_for_session! session, pr.product, pr.tech_path
    end
  end

  def self.set_for_session!(session, product, tpath)
    rec = by_session(session).by_tech_path(tpath).first_or_initialize
    rec.product = product
    rec.save
  end

  def self.head_by_session(session)
    head.by_session(session).first
  end

  def self.reset_by_session(session)
    by_session(session).delete_all
  end

  def property
    @property ||= SkuPart.find_by_id(tech_path.scan(/\/(\d+)\:\d+\z/).flatten.first)
  end

  def variant_presence
    if property.present? and property.products.exclude?(product)
      errors.add(:product_id, "Product must be present in part variants")
    end
  end
end
