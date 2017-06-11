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

  def duration
    @duration ||= required_products.map{|r| r.subtotal_duration}.reduce(&:+)
  end

  def duration_str
    mm, ss = duration.divmod(60)            #=> [4515, 21]
    hh, mm = mm.divmod(60)           #=> [75, 15]
    dd, hh = hh.divmod(24)           #=> [3, 3]
    "#{dd} days, #{hh} hours, #{mm} minutes and #{ss} seconds"
  end

  def sales
    @sales ||= tasks.map(&:total).reduce(&:+)
  end

  def requirements
    @requirements ||= required_products.map do |rp|
          t = Task.new(user_id: user_id,
                       sku_id: rp.result_sku_id,
                       supplier_id: rp.supplier_id,
                       price: rp.subtotal,
                       qty: rp.result_cnt)

          o = OpenStruct.new(ids: rp.ids,
                             parent_ids: rp.parent_ids,
                             subs: [],
                             residuals: build_residuals(rp, t),
                             rec: t)
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
      l.rec.residuals = sync_suppliers(l.subs.map(&:residuals).flatten, l.rec.supplier_id)
      del_wrappers(l.subs)
      l.rec
    end
  end

  def sync_suppliers(list, supplier_id)
    synced = list.map{|r| r.supplier_id = supplier_id; r}
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

  def build_residuals(row, t)
    row.residuals.map{|r| residual_to_tasks(r, row, t)}.flatten
  end

  def residual_to_tasks(r, row, src_task)
    (1..r.cnt.to_i).to_a.map do
      t = Task.new(user_id: user_id,
                   sku_id: row.sku_id,
                   price: 0,
                   state: :future_residual,
                   qty: r.qty.to_f)
      t.src = src_task
      t
    end
  end

end
