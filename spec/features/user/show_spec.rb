require 'rails_helper'

RSpec.describe 'profile show page', type: :feature do
  before(:each) do

    @user1 = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    
    visit profile_path(@user1)
  end
  it 'shows user info' do

    expect(page).to have_content(@user1.name)
    expect(page).to have_content(@user1.address)
    expect(page).to have_content(@user1.city)
    expect(page).to have_content(@user1.state)
    expect(page).to have_content(@user1.zip)
    expect(page).to have_content(@user1.email)
    expect(page).to have_link("Edit Profile")
  end
end

# User Story 19, User Profile Show Page

# As a registered user
# When I visit my profile page
# Then I see all of my profile data on the page except my password
# And I see a link to edit my profile data