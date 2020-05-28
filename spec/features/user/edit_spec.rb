require 'rails_helper'

RSpec.describe 'profile edit page', type: :feature do
  before(:each) do

    @user1 = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    
    visit profile_path(@user1)

    click_link "Edit Profile"
  end

  it 'shows prepopulated form that user is able to change' do

    expect(page).to have_field(:name, :with => @user1.name)
    expect(page).to have_field(:address, :with => @user1.address)
    expect(page).to have_field(:city, :with => @user1.city)
    expect(page).to have_field(:state, :with => @user1.state)
    expect(page).to have_field(:zip, :with => @user1.zip)
    expect(page).to have_field(:email, :with => @user1.email)
    expect(page).to_not have_field(:password)
    expect(page).to_not have_field(:password_confirmation)

    fill_in :name, with: "new name"
    fill_in :address, with: "new address"
    fill_in :city, with: "new city"
    fill_in :state, with: "new state"
    fill_in :zip, with: 12345
    fill_in :email, with: "newemail@test.com"

    click_button "Submit Form"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Your profile has been updated")

    expect(page).to have_content("new name")
    expect(page).to have_content("new address")
    expect(page).to have_content("new city")
    expect(page).to have_content("new state")
    expect(page).to have_content(12345)
    expect(page).to have_content("newemail@test.com")
  end
end

# As a registered user
# When I visit my profile page
# I see a link to edit my profile data
# When I click on the link to edit my profile data
# I see a form like the registration page
# The form is prepopulated with all my current information except my password
# When I change any or all of that information
# And I submit the form
# Then I am returned to my profile page
# And I see a flash message telling me that my data is updated
# And I see my updated information
