class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable,
         :trackable,
         :validatable,
        #  :registerable,
         :lockable
        #  :confirmable,
        #  :timeoutable,
        #  :omniauthable

  has_many :tasks
  has_many :user_suppliers, dependent: :destroy
  has_many :suppliers, through: :user_suppliers
  has_many :suppliers_tasks, through: :suppliers, class_name: 'Task', source: :tasks

  def sales_supplier
    suppliers.where(sales: true).first
  end

end
