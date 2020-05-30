require 'rails_helper'

RSpec.describe 'merchant dashboard show page', type: :feature do
  describe 'As a merchant' do
    before(:each) do

      @merchant1 = create(:merchant)
      @user1 = create(:user, role: "merchant", merchant_id: @merchant1.id)

      @merchant2 = create(:merchant)
      @user2 = create(:user, role: "merchant")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      
      visit merchant_dashboard_path
    end
    it 'I can see the name and full address of the merchant I work for' do

      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant1.address)
      expect(page).to have_content(@merchant1.city)
      expect(page).to have_content(@merchant1.state)
      expect(page).to have_content(@merchant1.zip)
      expect(page).to_not have_content(@merchant2.name)
    end
    it 'There is a link to my merchants item index page' do

      click_link "Items for #{@merchant1.name}"

      expect(current_path).to eq(merchant_items_path)
    end
  end
  describe 'As an admin' do
    before(:each) do
      
      @user2 = create(:user, role: "admin")
      
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)
      
      visit merchants_path
    end
    it 'I visit the merchants index page, I can click on a merchant name and see everything the merchant would see ' do

      click_link @merchant1.name 

      expect(current_path).to eq(admin_merchant_path(@merchant1))

      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant1.address)
      expect(page).to have_content(@merchant1.city)
      expect(page).to have_content(@merchant1.state)
      expect(page).to have_content(@merchant1.zip)
      expect(page).to_not have_content(@merchant2.name)
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

# As an admin user
# When I visit the merchant index page ("/merchants")
# And I click on a merchant's name,
# Then my URI route should be ("/admin/merchants/6")
# Then I see everything that merchant would see