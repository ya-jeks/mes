class Session < ActiveRecord::SessionStore::Session
  belongs_to :user
  has_many :chosen_variants, dependent: :destroy

end