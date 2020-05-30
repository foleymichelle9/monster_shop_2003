require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  describe 'As a merchant' do
    before(:each) do

      @merchant1 = create(:merchant)
      @user1 = create(:user, role: "merchant", merchant_id: @merchant1.id)

      @merchant2 = create(:merchant)
      @user2 = create(:user, role: "merchant")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      
      visit '/merchant/dashboard'
    end
    it 'I can see the name and full address of the merchant I work for' do

      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant1.address)
      expect(page).to have_content(@merchant1.city)
      expect(page).to have_content(@merchant1.state)
      expect(page).to have_content(@merchant1.zip)
    end
    it 'There is a link to my merchants item index page' do

      click_link "Items for #{@merchant1.name}"

      expect(current_path).to eq("/merchant/items")
    end
  end
end

# User Story 35, Merchant Dashboard displays Orders

# As a merchant employee
# When I visit my merchant dashboard ("/merchant")
# If any users have pending orders containing items I sell
# Then I see a list of these orders.
# Each order listed includes the following information:
# - the ID of the order, which is a link to the order show 
# page ("/merchant/orders/15")
# - the date the order was made
# - the total quantity of my items in the order
# - the total value of my items for that order

# User Story 36, Merchant's Items index page

# As a merchant employee
# When I visit my merchant dashboard
# I see a link to view my own items
# When I click that link
# My URI route should be "/merchant/items"