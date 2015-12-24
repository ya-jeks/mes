FactoryGirl.define do
  factory :uom do
    sequence(:name){|n| "uom_#{n}"}
    sequence(:description){|n| "description_#{n}"}
  end
end
