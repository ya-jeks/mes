FactoryGirl.define do
  factory :preset do
    sequence(:name) { |n| "preset_#{n}"}
  end
end
