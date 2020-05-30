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
  end
end

# User Story 34, Merchant Dashboard Show Page

# # As a merchant employee
# # When I visit my merchant dashboard ("/merchant")
# # I see the name and full address of the merchant I work for