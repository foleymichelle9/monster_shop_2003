require 'rails_helper'

RSpec.describe 'User Login-Logout' do
  before :each do
    @regular1 = create(:user, email: 'regular@email.com')
    @merchant1 = create(:user, email: 'merchant@eamil.com',role: 1)
    @admin1 = create(:user, email: 'admin@eamil.com',role: 2)
    @password = 'p123'

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
 
    
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
    it "can login merchants" do
      visit '/login'

      within("#login-form")do
        fill_in :email, with: @merchant1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      expect(page).to have_content("Welcome #{@merchant1.name}")
      expect(current_path).to eq("/merchant/dashboard")

    end
    it "can login admins" do
      visit '/login'

      within("#login-form")do
        fill_in :email, with: @admin1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      expect(page).to have_content("Welcome #{@admin1.name}")
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content(@admin1.name)
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
    it "if merchant it redirects to merchant dashboard" do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @merchant1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      visit '/login'
      expect(current_path).to eq('/merchant/dashboard')
    end
    it "if admin it redirects to admin dashboard" do

      visit '/login'

      within("#login-form")do
        fill_in :email, with: @admin1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      visit '/login'
      expect(current_path).to eq('/admin/dashboard')
    end
  end

  describe "US16" do
    it "users can logout, cart is returned to zero" do
      visit '/login'

      within("#login-form")do
        fill_in :email, with: @regular1.email
        fill_in :password, with: @password
        click_button "Login"
      end

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"

      expect(page).to have_content("#{@paper.name} was successfully added to your cart")
      expect(current_path).to eq("/items")

      within 'nav' do
        expect(page).to have_content("Cart: 1")
      end

      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      within 'nav' do
        expect(page).to have_content("Cart: 2")
      end
      
      

      visit '/logout'
      expect(current_path).to eq('/')
      expect(page).to have_content("You have logged out")
      expect(page).to have_content("Cart: 0")
    end
  end

end
     