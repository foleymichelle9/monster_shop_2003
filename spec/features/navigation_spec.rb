
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      within 'nav' do
        click_link "Register"
      end

      expect(current_path).to eq('/register')

      within 'nav' do
        click_link "Home"
      end

      expect(current_path).to eq('/')
      regular1 = create(:user, email: 'regular@email.com')
      password = 'p123'


      visit '/login'

      within 'nav' do
        expect(page).to have_content("Login")
        expect(page).to_not have_content("Profile")
        expect(page).to_not have_content("Logout")
      end

      within("#login-form")do
        fill_in :email, with: regular1.email
        fill_in :password, with: password

        click_button "Login"

      end
      within 'nav' do
        expect(page).to_not have_content("Login")
        expect(page).to have_content("Profile")
        expect(page).to have_content("Logout")
        click_link "Logout"
      end

      expect(current_path).to eq('/')
    end
    it "I cannot visit merchant pages" do

      visit merchant_dashboard_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end 
    it "I cannot visit admin pages" do

      visit admin_dashboard_path
      expect(page).to have_content("The page you were looking for doesn't exist.")

      @merchant = create(:merchant)

      visit admin_merchant_path(@merchant)
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end 
    it "I cannot visit profile pages" do

      @user = create(:user)
      @order = create(:order, user_id: @user.id)

      visit profile_path(@user)
      expect(page).to have_content("The page you were looking for doesn't exist.")
      
      visit profile_orders_path(@order)
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit profile_orders_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end 
  end
end
