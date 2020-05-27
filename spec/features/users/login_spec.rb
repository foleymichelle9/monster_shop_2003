require 'rails_helper'

RSpec.describe 'User Login-Logout' do
  describe "US13" do
    it "can login regulars" do
      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'user@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      user = User.last

      expect(page).to have_content("Welcome #{user.name}")
      expect(current_path).to eq("/profile")
      expect(page).to have_content('user@email.com')

    end
    it "can login merchants" do
      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'merchant@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      user = User.last

      expect(page).to have_content("Welcome #{user.name}")
      expect(current_path).to eq("/merchant")
      expect(page).to have_content('user@email.com')

    end
    it "can login admins" do
      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'admin@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      user = User.last

      expect(page).to have_content("Welcome #{user.name}")
      expect(current_path).to eq("/admin")
      expect(page).to have_content('user@email.com')
    end

  end

  describe "US14" do
    it 'US14 I can reject a user with bad email or password' do

      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'wrong@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      expect(page).to have_content("Your Credentials were Incorrect")
      expect(current_path).to eq("/login")

      within("#login-info")do
        fill_in :email, with: 'wrong@email.com'
        fill_in :password, with: 'wrong'
        click_button :submit
      end

      expect(page).to have_content("Your Credentials were Incorrect")
      expect(current_path).to eq("/login")

      within("#login-info")do
        fill_in :email, with: 'correct@email.com'
        fill_in :password, with: 'wrong'
        click_button :submit
      end

      expect(page).to have_content("Your Credentials were Incorrect")
      expect(current_path).to eq("/login")

      within("#login-info")do
        fill_in :email, with: 'correct@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end
      user = User.last

      expect(page).to have_content("Welcome #{user.name}")
      expect(current_path).to eq("/profile")
    end
  end

  describe "US15" do
    it "if regular user it redirects to user profile" do

      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'user@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      visit '/login'
      expect(current_path).to eq('/profile')
    end
    it "if merchant it redirects to merchant dashboard" do

      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'merchant@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      visit '/login'
      expect(current_path).to eq('/merchant')
    end
    it "if admin it redirects to admin dashboard" do

      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'admin@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      visit '/login'
      expect(current_path).to eq('/admin')
    end
  end

  describe "US16" do
    it "users can logout" do
      visit '/login'

      within("#login-info")do
        fill_in :email, with: 'admin@email.com'
        fill_in :password, with: 'correct'
        click_button :submit
      end

      add items to cart

      visit '/login'
      expect(current_path).to eq('/admin')
      click_button :Logout
      expect(current_path).to eq('/')
      expect(page).to have_css(".cart_indicator", text:0)
    end
  end

end
