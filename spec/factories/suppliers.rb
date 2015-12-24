FactoryGirl.define do
  factory :supplier do
    sequence(:code){|n| "code_#{n}"}
    sequence(:address){|n| "address_#{n}"}
    sequence(:capacity){|n| rand(144000)}
    sales false

    factory :sales_supplier do
      sales true
    end
  end
end
