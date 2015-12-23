class JsonLoader
  attr_reader :data, :path

  LOADERS = {
    'supplier' => SupplierLoader,
    'uom' => UomLoader,
    'part' => PartLoader,
    'product' => ProductLoader,
    'preset' => PresetLoader,
    'recalc' => RecalcLoader
  }

  def initialize(path)
    @data, @path = File.read(path), path
  end

  def call
    call_loader if entries.present?
  end

  private
    def call_loader
      p ['loading', path].join(' ')
      res = entries.map{|e| LOADERS[e.keys.first].new(e.values.first).call}
      p ['imported', res.size, 'from', path].join(' ')
      res
    end

    def entries
      @entries ||= JSON.load(data)
    end

end
