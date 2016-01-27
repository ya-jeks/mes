class Plan < ActiveRecord::Base
  belongs_to :user

  has_many :plan_tasks, dependent: :destroy
  has_many :tasks, through: :plan_tasks

  validates_presence_of :user

  before_save :build_tree
  after_save :plan!

  def required_products
    @required_products ||= RequiredProducts.new(task_ids).data
  end

  def total
    @total ||= required_products.map{|r| r.subtotal}.reduce(&:+)
  end

  def sales
    @sales ||= tasks.map(&:total).reduce(&:+)
  end

  def requirements
    @requirements ||= required_products.map do |rp|
          OpenStruct.new ids: rp.ids,
                         parent_ids: rp.parent_ids,
                         subs: [],
                         residuals: build_residuals(rp),
                         rec: Task.new(user_id: user_id,
                                       sku_id: rp.result_sku_id,
                                       supplier_id: rp.supplier_id,
                                       price: rp.subtotal,
                                       qty: rp.result_cnt)
    end
  end

  def sources
    @sources ||= tasks.map do |t|
      OpenStruct.new ids: [t.id.to_s],
                     parents_ids: [],
                     subs: [],
                     rec: t
    end
  end

  def plan!
    tasks.map{|t| t.plan!}
  end

  def build_tree
    res = build_subs(sources)
    del_wrappers(res)
  end

  def del_wrappers(list)
    list.map do |l|
      l.rec.tasks = l.subs.map(&:rec)
      l.rec.residuals = l.subs.map(&:residuals).flatten.map{|r| r.supplier_id = l.rec.supplier_id; r}
      del_wrappers(l.subs)
      l.rec
    end
  end

  def build_subs(list)
    list.map do |l|
      l.subs = subs_for(l)
      build_subs(l.subs)
      l
    end
  end

  def subs_for(rec)
    requirements.select{|r| (r.parent_ids & rec.ids).sort == rec.ids.sort}
  end

  def build_residuals(row)
    row.residuals.map{|r| residual_to_tasks(r, row)}.flatten
  end

  def residual_to_tasks(r, row)
    (1..r.cnt.to_i).to_a.map do
      Task.new(user_id: user_id,
               sku_id: row.sku_id,
               price: 0,
               state: :future_residual,
               qty: r.qty.to_f)
    end
  end

end
