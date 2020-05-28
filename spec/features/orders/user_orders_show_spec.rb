require 'rails_helper'

RSpec.describe 'User Login-Logout' do
  before :each do
    @regular2 = create(:user, email: 'regular2@email.com')
    @password = 'p123'
    visit '/login'
    within("#login-form")do
      fill_in :email, with: @regular2.email
      fill_in :password, with: @password
      click_button "Login"
    end
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @tire = @mike.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    
  end

  describe "US27" do
    it "profile displays a MY ORDERS link if orders" do
      visit '/profile'

      expect(page).to_not have_link("My Orders")

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"
      
      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      visit '/profile'

        within("#my-orders")do
          click_link("My Orders")
        end
        expect(current_path).to eq('/profile/orders')
        
      end
    
    
  end
  


end