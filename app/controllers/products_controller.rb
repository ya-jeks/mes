class ProductsController < ApplicationController
  before_action :set_sku,  only: [:show, :preset, :configure, :order]
  before_action :set_selected_product, only: [:show]

  def index
    @products = current_user.sales_supplier.products.order('id desc').page(params[:page]).per(6)
  end

  def order
    @task = Task.new user_id: current_user.id,
                     sku_id: @sku.id,
                     supplier_id: current_user.sales_supplier.id,
                     qty: task_params[:qty].to_f,
                     due_date: Time.current,
                     price: task_params[:qty].to_f*@sku.sku_suppliers.where(supplier: current_user.sales_supplier).try(:first).try(:price).to_f
    cvs = ChosenVariant.by_session(session_record).where.not(tech_path: '')
    @task.task_properties = cvs.map do |cv|
      vp = VariantPrice.where(product_id: @sku.product.id, variant_id: cv.product_id, tech_path: cv.tech_path).first
      TaskProperty.new tech_path: cv.tech_path,
                       product: cv.product,
                       price: vp.present? ? vp.price : 0
    end

    if @task.save
      redirect_to tasks_path
    else
      redirect_to :back, alert: @task.errors.messages
    end
  end

  def preset
    preset = @sku.product.presets.find(preset_params[:id])
    ChosenVariant.set_preset_for_session!(session_record, preset)
    session['preset_id'] = preset_params[:id]

    redirect_to product_path(@sku.product)
  end

  def configure
    if chosen = Product.find_by_id(params[:product_id].presence) and
         ChosenVariant.set_for_session!(session_record, chosen, params[:tech_path])
         session['prop_configured'] = true
      redirect_to product_path(@sku.product)
    else
      redirect_to :back
    end
  end

  def show
    comps = SkuComponents.new(sku_id: @sku.id, session_id: session_record.id).call
    @components = comps.collection
    @price = @sku.sku_suppliers.where(supplier: current_user.sales_supplier).try(:first).try(:price).to_f + comps.summ
    @task = Task.new sku: @sku, supplier: current_user.sales_supplier, qty: 1
    if @sku.product.presets.any?
      @chosen_preset = session['preset_id'].presence||@sku.product.product_presets.where(main: true).first.preset
      @show_comps = true if session['prop_configured']
    else
      @show_comps = true
    end

    @components.map{|pr| ChosenVariant.set_for_session!(session_record, pr.variant, pr.tech_path)}
  end

  private
    def set_sku
      @sku = Product.find(params[:id]).skus.first
    end

    def set_selected_product
      if other_product_selected
        ChosenVariant.reset_by_session(session_record) if prev_product.present?
        ChosenVariant.set_head_for_session!(session_record, @sku.product)
        session['prop_configured'] = false
        session['preset_id'] = nil
      end
    end

    def prev_product
      @prev_product ||= ChosenVariant.head_by_session(session_record).try(:product)
    end

    def other_product_selected
      prev_product.try(:id) != @sku.product_id
    end

    def task_params
      params[:task].permit(:id, :qty, :sku_id)
    end

    def preset_params
      params[:preset].permit(:id)
    end

end
