class Supplier < ActiveRecord::Base

  has_many :sku_suppliers, dependent: :destroy
  has_many :skus, -> { readonly }, through: :sku_suppliers
  has_many :products, -> { readonly }, through: :skus

  has_many :tasks
  has_many :user_suppliers, dependent: :destroy
  has_many :users, through: :user_suppliers

  validates :code, presence: true, uniqueness: true
  validates :address, presence: true

  after_initialize :generate_code

  def generate_code
    if self.code.nil?
      self.code = loop do
        random_code = SecureRandom.hex(6)
        break random_code unless self.class.exists?(code: random_code)
      end
    end
  end

end
