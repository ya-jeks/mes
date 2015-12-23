class PresetLoader < SeedLoader

  def load
    preset.product_presets = product_presets
    preset.preset_variants = preset_variants
    preset.save!
    preset
  end

  def preset
    @preset ||= Preset.create! name: params['name']
  end

  def product_presets
    params['products'].map do |pp|
      ProductPreset.new product: Product.where(name: pp['name']).first,
                        preset: preset, main: !!pp['main']
    end
  end

  def preset_variants
    params['variants'].map do |v|
      PresetVariant.new tech_path: v['tech_path'],
                        product: Product.find(v['product_id']),
                        preset: preset
    end
  end
end