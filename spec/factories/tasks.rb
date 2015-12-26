FactoryGirl.define do
  factory :task do
    sku
    user
    supplier
    sequence(:state) { 'initialized'}
    qty { rand(10)}
  end
end
