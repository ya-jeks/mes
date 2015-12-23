class PartLoader < SeedLoader

  def load
    part.part_products = part_products if params['products'].present?
    part.save!
  end

  def part
    @part ||= Part.where(name: params['name']).first_or_initialize
  end

  def part_products
    params['products'].map{|r| PartProduct.where(product_params(r)).first_or_initialize}
  end

  def product_params(pr)
    {
      product: Product.where(name: pr['name']).first,
      part: part
    }
  end

end
