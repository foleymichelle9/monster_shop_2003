FactoryBot.define do
  factory :order do
    sequence(:name) {|n| "Order #{n}" }
    sequence(:address) {|n| "Address #{n}" }
    sequence(:city) {|n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip, (11111..99999).cycle) { |n| 1 + n }
  end
end