FactoryGirl.define do
  factory :product do
    sequence(:name){|n| "product_#{n}"}
    sequence(:description){|n| "description_#{n}"}
  end
end
