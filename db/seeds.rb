def load_seed(path)
  JsonLoader.new(path).call
end

puts "Loading seeds..."
load_seed "#{Rails.root}/db/seeds/uoms.json"
load_seed "#{Rails.root}/db/seeds/suppliers.json"

load_seed "#{Rails.root}/db/seeds/hpl.json"
load_seed "#{Rails.root}/db/seeds/edge_pvc.json"
load_seed "#{Rails.root}/db/seeds/ldsp.json"
load_seed "#{Rails.root}/db/seeds/textile.json"
load_seed "#{Rails.root}/db/seeds/packing.json"
load_seed "#{Rails.root}/db/seeds/materials.json"

load_seed "#{Rails.root}/db/seeds/table_legs.json"

load_seed "#{Rails.root}/db/seeds/tables/lhombre_base.json"
load_seed "#{Rails.root}/db/seeds/tables/lhombre_top.json"
load_seed "#{Rails.root}/db/seeds/tables/lhombre.json"

load_seed "#{Rails.root}/db/seeds/tables.json"

require Rails.root.join 'db/seeds/users'
require Rails.root.join 'db/seeds/techs'
require Rails.root.join 'db/seeds/variant_prices'

load_seed "#{Rails.root}/db/seeds/presets.json"
load_seed "#{Rails.root}/db/seeds/recalcs.json"

load_seed "#{Rails.root}/db/seeds/hplm.json"

puts "Done"