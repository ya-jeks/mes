class RecalcLoader < SeedLoader

  def load
    recalc.qty = params['qty']
    recalc.save!
  end

  def recalc
    @recalc ||= Recalc.where(sku: sku, uom: uom).first_or_initialize
  end

  def sku
    @sku ||= Sku.where(product: product, uom: product_uom).first_or_initialize
  end

  def uom
    @uom ||= Uom.where(name: params['uom']).first_or_initialize
  end

  def product
    @product ||= Product.where(name: params['sku']['product']).first
  end

  def product_uom
    @product_uom ||= Uom.where(name: params['sku']['uom']).first
  end

end
