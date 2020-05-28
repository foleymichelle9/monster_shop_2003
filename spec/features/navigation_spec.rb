
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
      save_and_open_page
      
      within 'nav' do
        expect(page).to_not have_content("Login")
        expect(page).to have_content("Profile")
        expect(page).to have_content("Logout")
        click_link "Logout"
      end

      expect(current_path).to eq('/')
    end
  end
end
