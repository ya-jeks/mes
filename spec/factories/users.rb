FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email_#{n}@email.domain" }
    sequence(:password) { |n| "password_#{n}" }
    sequence(:phone) { |n| FFaker::PhoneNumber.phone_number }
  end
end
