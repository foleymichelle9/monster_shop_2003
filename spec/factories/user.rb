FactoryBot.define do
    factory :user do
      sequence(:name) {|n| "User #{n}" }
      sequence(:address) {|n| "Address #{n}" }
      sequence(:city) {|n| "City #{n}" }
      sequence(:state) { |n| "State #{n}" }
      sequence(:zip, (11111..99999).cycle) { |n| 1 + n }
      sequence(:email) { |n| "User #{n}@gmail.com" }
      password { "p123"}
    end
  end