require 'rqrcode'

class Task < ActiveRecord::Base

  include AASM
  include PriceHelpers
  include StateHelpers
  include StateCallbacks
  include SupplierHelpers
  include ValidationHelpers

  belongs_to :sku
  belongs_to :user
  belongs_to :supplier

  has_one :plan_task
  has_one :plan, through: :plan_task
  has_one :uom, through: :sku
  has_one :product, through: :sku
  has_one :task_srcs, class_name: 'TaskSrc'
  has_one :src, class_name: 'Task', through: :task_srcs

  has_many :task_relations
  has_many :residual_relations
  has_many :parents, class_name: 'Task', through: :task_relations
  has_many :parent_relations, class_name: 'TaskRelation', foreign_key: :parent_id, dependent: :destroy
  has_many :value_relations, class_name: 'ResidualRelation', foreign_key: :residual_id, dependent: :destroy
  has_many :parents_suppliers, class_name: 'Supplier', through: :parents, source: :supplier
  has_many :tasks, through: :parent_relations, dependent: :destroy
  has_many :residuals, through: :residual_relations, dependent: :destroy, source: :residual
  has_many :value_tasks, class_name: 'Task', through: :value_relations, dependent: :destroy, source: :task
  has_many :tasks_suppliers, class_name: 'Supplier', through: :tasks, source: :supplier
  has_many :task_properties, dependent: :destroy
  has_many :neighbors, class_name: 'Task', through: :parents, source: :tasks

  validates_presence_of :sku, :user, :supplier

  scope :by_sku, ->(s) { where(sku: s) }
  scope :by_user, ->(u) { where(user: u) }
  scope :by_supplier, ->(v) { where(supplier: v).order('state desc, sku_id, created_at desc') }

  scope :between_dates, ->(start_date, end_date) {
    where('tasks.updated_at between ? and ?', Date.parse(start_date), Date.parse(end_date))
  }

  scope :top, -> {
    joins('left join task_relations tr on tr.task_id=tasks.id').
      where('tr.id is null')
  }

  scope :accessible_to_view_by, ->(user) {
    where('((tasks.user_id = ? and tasks.id not in(?)) or tasks.supplier_id in (?))',
        user.id,
        TaskRelation.select(:task_id).distinct,
        Supplier.joins(:users).where(users: {id: user.id}).select(:id))}

  scope :accessible_in_list_for, ->(user) {
    accessible_to_view_by(user).
    where.not(id: Task.joins(:tasks).
                  accessible_to_view_by(user).
                  select('tasks_tasks.id'))}

  scope :accessible_to_accept_by, ->(user) {
    joins(:parents).where('parents_tasks.id in (?)',
        Task.accessible_in_list_for(user).select(:id))}

  aasm column: :state do
    state :initialized, initial: true
    state :future_residual
    state :planned, :after_enter => :after_plan
    state :finished, :after_enter => :after_finish
    state :delivered
    state :accepted
    state :rejected

    event :plan do
      transitions from: [:initialized, :rejected], to: :planned
    end
    event :finish do
      transitions from: :planned, to: :finished
    end
    event :deliver do
      transitions from: :finished, to: :delivered
    end
    event :accept do
      transitions from: :delivered, to: :accepted
    end
    event :reject do
      transitions from: :delivered, to: :rejected
    end
    event :make_residual do
      transitions from: :future_residual, to: :finished
    end
  end

  def build_props_from(props)
    self.task_properties = props.map do |prop|
      vp = VariantPrice.where(product_id: sku.product.id,
                              variant_id: prop.product_id,
                              tech_path: prop.tech_path).first

      TaskProperty.new tech_path: prop.tech_path,
                       product_id: prop.product_id,
                       price: vp.present? ? vp.price : 0
    end
  end

  def qrcode
    RQRCode::QRCode.new(id.to_s).as_png
  end

end
