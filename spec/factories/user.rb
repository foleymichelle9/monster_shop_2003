FactoryBot.define do
  factory :user do
    name { Faker::TvShows::GameOfThrones.character }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Number.number(digits: 5) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 0 }
  end
end