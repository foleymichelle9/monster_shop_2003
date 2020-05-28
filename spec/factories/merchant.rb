FactoryBot.define do
  factory :merchant do
    sequence(:name) {|n| "Item #{n}" }
    sequence(:address) {|n| "Address #{n}" }
    sequence(:city) {|n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip, (11111..99999).cycle) { |n| 1 + n }
  end
end