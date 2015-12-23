class UserSupplier < ActiveRecord::Base
  belongs_to :user
  belongs_to :supplier

  validates_presence_of :user, :supplier
end
