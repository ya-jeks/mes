class SeedLoader
  attr_reader :params

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def load
  end

  def call
    load
  rescue => e
    puts params
    raise e
  end

end
