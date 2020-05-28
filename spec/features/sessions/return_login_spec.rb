require 'rails_helper'

RSpec.describe 'User Login-Logout' do
  before :each do
    @regular1 = create(:user, email: 'regular@email.com')
    @merchant1 = create(:user, email: 'merchant@eamil.com',role: 1)
    @admin1 = create(:user, email: 'admin@eamil.com',role: 2)
    @password = 'p123'
    
  end

  describe "US13" do
    it "can login regulars" do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      expect(page).to have_content("Welcome #{@regular1.name}")
      expect(current_path).to eq("/profile")
      expect(page).to have_content("#{@regular1.email}")

    end
    xit "can login merchants" do
      visit '/login'

      within("#login-form")do
        fill_in :email, with: @merchant1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      expect(page).to have_content("Welcome #{@merchant1.name}")
      expect(current_path).to eq("/merchant")
      expect(page).to have_content(@merchant1.email)

    end
    xit "can login admins" do
      visit '/login'

      within("#login-form")do
        fill_in :email, with: @admin1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      expect(page).to have_content("Welcome #{@admin1.name}")
      expect(current_path).to eq("/admin")
      expect(page).to have_content(@admin1.email)
    end

  end

  describe "US14" do
    it 'US14 I can reject a user with bad email or password' do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: 'wrong@email.com'
        fill_in :password, with: @password
        click_button "Login"
      end

      expect(page).to have_content("Incorrect username or password")
      expect(current_path).to eq('/login')

      within("#login-form")do
        fill_in :email, with: 'wrong@email.com'
        fill_in :password, with: 'wrong'
        click_button "Login"
      end

      expect(page).to have_content("Incorrect username or password")
      expect(current_path).to eq('/login')

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: 'wrong'
        click_button "Login"
      end

      expect(page).to have_content("Incorrect username or password")
      expect(current_path).to eq('/login')

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: @password
        click_button "Login"
      end
      user = User.last

      expect(page).to have_content("Welcome #{@regular1.name}")
      expect(current_path).to eq("/profile")
    end
  end

  describe "US15" do
    it "if regular user it redirects to user profile" do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: @password
        click_button "Login"
      end
      visit '/login'

      expect(current_path).to eq('/profile')
    end
    xit "if merchant it redirects to merchant dashboard" do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @merchant1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      visit '/login'
      expect(current_path).to eq('/merchant')
    end
    xit "if admin it redirects to admin dashboard" do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @admin1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      visit '/login'
      expect(current_path).to eq('/admin')
    end
  end

  describe "US16" do
    xit "users can logout" do
      visit '/login'

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: @password
        click_button "Login"
      end
      
      

      visit '/logout'
      expect(current_path).to eq('/')
      expect(page).to have_content("You have logged out")
      # expect(page).to have_css(".cart_indicator", text:0)
    end
  end

end
