class ProductsController < ApplicationController
  before_action :set_sku,  only: [:show, :preset, :configure]

  def index
    @products = current_user.sales_dep.products.page(params[:page]).per(6)
  end

  def preset
    @preset = @sku.presets.find(preset_params[:id])
    session['preset_id'] = preset_params[:id]

    redirect_to product_path(@sku.product)
  end

  def configure
    if chosen = Product.find_by_id(params[:product_id])
      session['props'][chosen.id] = params[:tech_path]
      session['show_props'] = true

      redirect_to product_path(@sku.product)
    else
      redirect_to :back
    end
  end

  def show
    comps = SkuComponents.new(sku_id: @sku.id, session_id: sess.id).data
    @components = comps.collection
    @price = @sku.price_on(current_user.sales_dep) + comps.summ
    @task = Task.new sku: @sku, supplier: current_user.sales_dep, qty: 1
    @components.map{|pr| session['props'][pr.variant.id] = pr.tech_path}
  end

  private
    def set_sku
      @sku = Product.find(params[:id]).skus.first
      session['sku_id'] = @sku.id
    end

    def preset_params
      params[:preset].permit(:id)
    end

end
