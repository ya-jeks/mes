FactoryGirl.define do
  factory :product_supplier do
    product
    uom
    supplier
    sequence(:price){|n| n+rand(100)}
    sequence(:duration){|n| n+rand(100)}

  end
end
