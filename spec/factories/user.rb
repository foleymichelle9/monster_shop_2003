FactoryBot.define do
    factory :user do
      name { Faker::Movies::PrincessBride.character }
      address { Faker::Address.street_address }
      city { Faker::Address.city }
      state { Faker::Address.state }
      zip { Faker::Number.number(digits: 5) }
      email { "#{Faker::Movies::PrincessBride.character}@gmail.com" }
      password { "p123"}
    end
  end