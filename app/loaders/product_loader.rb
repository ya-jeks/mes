class ProductLoader < SeedLoader

  def load
    sku.sku_parts = sku_parts if params['parts'].present?
    sku.sku_suppliers = sku_suppliers if params['suppliers'].present?

    product.save!
    sku.product = product
    sku.save!

    make_part! if params['container']
    product
  end

  def product
  	@product ||= begin
      pr = Product.where(name: params[:name]).first_or_initialize
      pr.description = params['description'] if params['description'].present?
      pr
    end
  end

  def uom
    @uom ||= Uom.where(name: params['uom']).first
  end

  def sku
    @sku ||= Sku.where(product: product, uom_id: uom.id).first_or_initialize
  end

  def make_part!
    part = Part.where(name: product.name).first_or_initialize
    part.part_products = [PartProduct.new(product: product)]
    part.save!
  end

  def sku_parts
    params['parts'].map{|r| sku_part_by(r)}
  end

  def sku_suppliers
    params['suppliers'].map{|r| sku_supplier_by(r)}
  end

  def sku_part_by(pr)
    _part = Part.where(name: pr['source']).first
    raise "Part does not exists: #{pr['source']}" if _part.nil?

    _uom = Uom.where(name: pr['uom']).first
    up = SkuPart.where(
      sku_id: sku.id,
      part_id: _part.id,
      uom_id: _uom.id
    ).first_or_initialize

    _part.products.map{|prod| u = Sku.where(product: prod, uom: _uom).first_or_initialize; u.save! }

    up.name = pr['name'] if pr['name'].present?
    up.qty = pr['qty']
    up
  end

  def sku_supplier_by(pr)
    _supplier = Supplier.where(code: pr['code']).first
    raise "Supplier does not exists: #{pr['code']}" if _supplier.nil?

    pv = SkuSupplier.where(supplier_id: _supplier.id, sku_id: sku.id).first_or_initialize
    pv.duration = pr['duration']
    pv.price = pr['price']
    pv
  end

end
