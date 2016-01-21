class ProductsController < ApplicationController
  before_action :set_sku, only: [:show, :preset, :configure]
  before_action :set_components, only: :show
  before_action :set_task, only: :show

  def index
    @products = current_user.products.page(params[:page]).per(6)
  end

  def preset
    @preset = @sku.presets.find(preset_params[:id])
    set_preset(@preset)
    redirect_to product_path(@sku.product)
  end

  def configure
    if chosen = Product.find_by_id(params[:product_id])
      set_prop(chosen, params[:tech_path])
      redirect_to product_path(@sku.product)
    else
      redirect_to :back
    end
  end

  def show
    @properties = @components.properties
    @price = @sku.price_on(current_user.sales_dep) + @components.summ
  end

  private
    def set_sku
      @sku = Product.find(params[:id]).skus.first
      prop_handler.set_sku(@sku)
    end

    def set_components
      @components = @sku.components_for(sess)
    end

    def set_task
      @task = Task.new sku: @sku,
                       supplier: current_user.sales_dep,
                       qty: 1
    end

    def set_preset(preset)
      session['preset_id'] = preset.id
      session['show_props'] = false
      prop_handler.set_preset(preset)
    end

    def set_prop(chosen, tech_path)
      session['show_props'] = true
      prop_handler.set_prop(chosen, tech_path)
    end

    def prop_handler
      @prop_handler ||= Session::PropHandler.new(sess)
    end

    def preset_params
      params[:preset].permit(:id)
    end
end
