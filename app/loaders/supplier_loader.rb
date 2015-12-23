class SupplierLoader < SeedLoader

  def load
    Supplier.where(params).first_or_create!
  end

end
