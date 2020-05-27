require 'rails_helper'

RSpec.describe 'User Login-Logout' do
  before :each do
    @regular1 = create(:user)
    
  end

  describe "US13" do
    it "can login regulars" do

      visit new_session_path

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: 'p123'
        click_button "Login"
      end

      user = User.last

      expect(page).to have_content("Welcome #{@regular1.name}")
      expect(current_path).to eq("/profile")
      expect(page).to have_content("#{@regular1.email}")

    end
    xit "can login merchants" do
      visit new_session_path

      within("#login-info")do
        fill_in :email, with: 'merchant@email.com'
        fill_in :password, with: 'correct'
        click_button "Login"
      end

      user = User.last

      expect(page).to have_content("Welcome #{@regular1.name}")
      expect(current_path).to eq("/merchant")
      expect(page).to have_content('user@email.com')

    end
    xit "can login admins" do
      visit new_session_path

      within("#login-info")do
        fill_in :email, with: 'admin@email.com'
        fill_in :password, with: 'correct'
        click_button "Login"
      end

      user = User.last

      expect(page).to have_content("Welcome #{@regular1.name}")
      expect(current_path).to eq("/admin")
      expect(page).to have_content('user@email.com')
    end

  end

  describe "US14" do
    it 'US14 I can reject a user with bad email or password' do

      visit new_session_path

      within("#login-form")do
        fill_in :email, with: 'wrong@email.com'
        fill_in :password, with: 'p123'
        click_button "Login"
      end

      expect(page).to have_content("Incorrect username or password")
      expect(current_path).to eq(new_session_path)

      within("#login-form")do
        fill_in :email, with: 'wrong@email.com'
        fill_in :password, with: 'wrong'
        click_button "Login"
      end

      expect(page).to have_content("Incorrect username or password")
      expect(current_path).to eq(new_session_path)

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: 'wrong'
        click_button "Login"
      end

      expect(page).to have_content("Incorrect username or password")
      expect(current_path).to eq(new_session_path)

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: 'p123'
        click_button "Login"
      end
      user = User.last

      expect(page).to have_content("Welcome #{@regular1.name}")
      expect(current_path).to eq("/profile")
    end
  end

  describe "US15" do
    xit "if regular user it redirects to user profile" do

      visit new_session_path

      within("#login-info")do
        fill_in :email, with: 'user@email.com'
        fill_in :password, with: 'correct'
        click_button "Login"
      end

      visit new_session_path
      expect(current_path).to eq('/profile')
    end
    xit "if merchant it redirects to merchant dashboard" do

      visit new_session_path

      within("#login-info")do
        fill_in :email, with: 'merchant@email.com'
        fill_in :password, with: 'correct'
        click_button "Login"
      end

      visit new_session_path
      expect(current_path).to eq('/merchant')
    end
    xit "if admin it redirects to admin dashboard" do

      visit new_session_path

      within("#login-info")do
        fill_in :email, with: 'admin@email.com'
        fill_in :password, with: 'correct'
        click_button "Login"
      end

      visit new_session_path
      expect(current_path).to eq('/admin')
    end
  end

  describe "US16" do
    xit "users can logout" do
      visit new_session_path

      within("#login-info")do
        fill_in :email, with: 'admin@email.com'
        fill_in :password, with: 'correct'
        click_button "Login"
      end

      add items to cart

      visit new_session_path
      expect(current_path).to eq('/admin')
      click_button :Logout
      expect(current_path).to eq('/')
      expect(page).to have_css(".cart_indicator", text:0)
    end
  end

end
