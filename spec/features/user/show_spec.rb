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

