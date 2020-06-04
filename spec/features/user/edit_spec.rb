require 'rails_helper'

RSpec.describe 'profile edit page', type: :feature do
  before(:each) do

    @user1 = create(:user)

    @user2 = create(:user, email: "newemail@test.com")

    visit '/login'
    within("#login-form")do
      fill_in :email, with: @user1.email
      fill_in :password, with: 'p123'
      click_button "Login"
    end

    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    
    visit "/profile"

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
    fill_in :email, with: "testemail@testemail.com"
    
    click_button "Submit Form"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Your profile has been updated")

    expect(page).to have_content("new name")
    expect(page).to have_content("new address")
    expect(page).to have_content("new city")
    expect(page).to have_content("new state")
    expect(page).to have_content("new state")
    expect(page).to have_content(12345)
    expect(page).to have_content("testemail@testemail.com")
  end

  it 'will not let user change e-mail if new e-mail address is already in use' do

    fill_in :name, with: "new name"
    fill_in :address, with: "new address"
    fill_in :city, with: "new city"
    fill_in :state, with: "new state"
    fill_in :zip, with: 12345
    fill_in :email, with: "newemail@test.com"

    click_button "Submit Form"

    expect(current_path).to eq("/users/#{@user1.id}/edit")
    expect(page).to have_content("Email has already been taken")
  end
end
RSpec.describe 'password edit page', type: :feature do
  before(:each) do

    @user1 = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    
    visit "/profile"

    click_link "Edit Password"
  end

  it 'allows user to edit their password' do

    fill_in :password, with: "new password"
    fill_in :password_confirmation,	with: "new password"

    click_button "Submit"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Your password has been updated")
  end 

  it 'does not allow user to edit password if passwords do not match' do

    fill_in :password, with: "new password"
    fill_in :password_confirmation,	with: "new"

    click_button "Submit"

    expect(current_path).to eq("/users/#{@user1.id}/edit_password")
    expect(page).to have_content("passwords do not match")
  end 
end
