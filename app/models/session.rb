class Session < ActiveRecord::SessionStore::Session
  belongs_to :user
  has_many :chosen_products, dependent: :destroy
  has_many :chosen_props, -> { props}, class_name: 'ChosenProduct'
  has_one :chosen_head, -> { head}, class_name: 'ChosenProduct'
  has_one :chosen_product, through: :chosen_head, class_name: 'Product', source: :product

end
