FactoryBot.define do
  factory :order do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Number.number(digits: 5) }
  end
end