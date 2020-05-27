FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.material }
    price { Faker::Number.number(digits: 2) }
    sequence(:image) { |n| "http://img.com/#{1 + n}" }
    active? { true }
    inventory { Faker::Number.number(digits: 2) }
    merchant
  end
end