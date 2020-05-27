require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do 
  describe "When I click on the 'register' link in the nav bar" do
    before(:each) do
      @user_info1 = {name: "Mike Dao",
        address:  "246 test Ave",
        city:     "Denver",
        state:    "CO",
        zip:      "80204",
        email:    "email@example.com",
        password: "mikepw"}

      @user_info2 = {name: "Meg Stang",
        address:  "369 Testing ST ",
        city:     "Denver",
        state:    "CO",
        zip:      "80202",
        email:    "123email@example.com",
        password: "megpw"}
    end

    it "Then I am on the user registration page ('/register')" do
      visit '/items'

      click_on 'Register'

      expect(current_path).to eq('/register')

      fill_in "Name",	with: "John" 
      fill_in "Address",	with: "123 Test St." 
      fill_in "City",	with: "Denver" 
      fill_in "State",	with: "Colorado" 
      fill_in "Zip",	with: "80234" 
      fill_in "Email",	with: "123test@email.com" 
      fill_in "Password",	with: "password123" 
      fill_in "Confirm Password",	with: "password123" 

      click_on 'Submit Form'

      expect(current_path).to eq("/profile") 

    end

    it "cannot create a new profile with an email address already in use" do
      visit "/register"
      fill_in :name, with: @user_info1[:name]
      fill_in :address,	with: @user_info1[:address]
      fill_in :city, with: @user_info1[:city]
      fill_in :state,	with: @user_info1[:state]
      fill_in :zip,	with: @user_info1[:zip]
      fill_in :email,	with: @user_info1[:email]
      fill_in :password, with: @user_info1[:password]
      fill_in :confirm_password,	with: @user_info1[:password]
      click_button "Submit Form"

      visit "/register"
      fill_in :name, with: @user_info2[:name]
      fill_in :address,	with: @user_info2[:address]
      fill_in :city, with: @user_info2[:city]
      fill_in :state,	with: @user_info2[:state]
      fill_in :zip,	with: @user_info2[:zip]
      fill_in :email,	with: @user_info1[:email]
      fill_in :password, with: @user_info2[:password]
      fill_in :confirm_password,	with: @user_info2[:password]
      click_button "Submit Form"

      expect(current_path).to eq("/register")
      expect(page).to have_content("Email has already been taken")
      expect(page).to have_field(:name, with: @user_info2[:name])
      expect(page).to have_field(:address, with: @user_info2[:address])
      expect(page).to have_field(:city, with: @user_info2[:city])
      expect(page).to have_field(:state, with: @user_info2[:state])
      expect(page).to have_field(:zip, with: @user_info2[:zip])
    end

    it "cannot create a new profile with missing required fields" do
      visit "/register"
      fill_in :name, with: @user_info2[:name]
      fill_in :address,	with: @user_info2[:address]
      fill_in :city, with: @user_info2[:city]
      fill_in :state,	with: @user_info2[:state]
      # Missing zip field
      fill_in :email,	with: @user_info2[:email]
      fill_in :password, with: @user_info2[:password]
      fill_in :confirm_password,	with: @user_info2[:password]
      click_button "Submit"

      expect(current_path).to eq("/register") 
      expect(page).to have_content("zip can't be blank, please try again.")
    end  
  end
end