class Session < ActiveRecord::SessionStore::Session
  belongs_to :user
  has_many :chosen_products, dependent: :destroy
  has_many :chosen_props, -> { props}, class_name: 'ChosenProduct'
  has_one :chosen_head, -> { head}, class_name: 'ChosenProduct'
  has_one :chosen_product, through: :chosen_head, class_name: 'Product', source: :product

  before_save :revise_data

  def revise_data
    p [:data, data]
  end

  def update_sku
    if data['sku_id'].present? and
       chosen_product.present? and
       sku = Sku.find_by_id(data['sku_id']) and
       sku.product_id != chosen_product.id

      set_product!(sku.product)
      data['show_props'] = false
      data['preset_id'] = nil
    end
  end

  def update_preset
    if data['preset_id'].present? and
       preset = Preset.find_by_id(data['preset_id'])

      set_preset! preset
      data['show_props'] = false
    end
  end

  def update_props
    session['show_props'] = true
  end

  def set_preset!(preset)
    chosen_props.delete_all
    preset.preset_variants.map{|pr| set_prop!(pr.product, pr.tech_path)}
  end

  def reset_chosen
    chosen_products.delete_all
  end

  def set_product!(product)
    reset_chosen
    set_prop!(product, '')
  end

  def set_prop!(product, tech_path)
    rec = chosen_products.by_tech_path(tech_path).first_or_initialize
    rec.product = product
    rec.save!
  end
end
