FactoryGirl.define do
  factory :sku_supplier do
    sku
    supplier
    sequence(:price){|n| n+rand(100)}
    sequence(:duration){|n| n+rand(100)}
    
  end
end
