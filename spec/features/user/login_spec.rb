require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do 
  describe "When I click on the 'register' link in the nav bar" do
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
      save_and_open_page
    end
  end
end

#   As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
# - my name
# - my street address
# - my city
# - my state
# - my zip code
# - my email address
# - my preferred password
# - a confirmation field for my password

# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in