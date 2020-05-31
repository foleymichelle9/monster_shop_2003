require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a regular user' do
    before(:each) do

      @merchant = create(:merchant)
      @user = create(:user, merchant_id: @merchant.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'I cannot access any merchant paths' do
      
      visit merchant_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
      
      visit merchant_items_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
    it 'I cannot access any admin paths' do
      
      visit admin_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
      
      visit admin_merchant_path(@merchant)
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end 
end 