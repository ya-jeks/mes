class UomLoader < SeedLoader

  def load
    Uom.where(params).first_or_create!
  end

end
