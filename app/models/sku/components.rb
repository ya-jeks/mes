class Sku::Components
  attr_reader :sku_id, :session_id

  def initialize(sku_id:, session_id:)
    @sku_id, @session_id = sku_id, session_id
  end

  def data
    OpenStruct.new properties: properties,
                   summ: properties.map(&:price).map(&:to_f).reduce(&:+).to_f
  end

  private
    def sku
      @sku ||= Sku.find(sku_id)
    end

    def properties
      @properties ||= visible_collection.reduce([]){|r, pr| r << with_variants(pr); r}
    end

    def visible_collection
      @visible_collectiion ||= raw_collection.select{|pr| pr.visible == 't'}
    end

    def raw_collection
      @raw_collection ||= fetcher.call
    end

    def fetcher
      @fetcher ||= Fetcher.new(sku_id: sku_id, session_id: session_id)
    end

    def variants_hash
      @variants_hash ||= props.map{|prop| {id: prop.id, variants: prop.products.to_a}}
    end

    def props
      @props ||= SkuPart.eager_load(:sku).where(id: props_ids).order(:id)
    end

    def props_ids
      @props_ids = raw_collection.map{|prop| prop.id.to_i}
    end

    def with_variants(prop)
      prop.variants = variants_hash.select{|v| v[:id] == prop.id.to_i}.first[:variants]

      prop.variant = prop.variants.select{|v| v.id == prop.selected_product_id.to_i}.first

      prop.variants_prices = variants_prices.to_a.select do |vp|
        rec = props.to_a.select{|pr| pr.id == prop.id.to_i}.first
        prop.tech_path == vp.tech_path
      end

      prop
    end

    def variants_prices
      @variants_prices ||= VariantPrice.where(product_id: sku.product_id).order(:id)
    end
end
