class Session::PropHandler
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def set_sku(sku)
    if session.chosen_product and
       sku.product_id != session.chosen_product.id

      set_product(sku.product)
    end
  end

  def set_preset(preset)
    session.chosen_props.delete_all
    preset.preset_variants.map{|pr| set_prop(pr.product, pr.tech_path)}
  end

  def reset_chosen
    session.chosen_products.delete_all
  end

  def set_product(product)
    reset_chosen
    set_prop(product, '')
  end

  def set_prop(product, tech_path)
    rec = session.chosen_products.by_tech_path(tech_path).first_or_initialize
    rec.product = product
    rec.save
  end
end
