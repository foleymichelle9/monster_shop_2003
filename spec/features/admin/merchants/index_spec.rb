require 'rails_helper'

RSpec.describe 'Admin Merchant Index Page' do
  before :each do
    @admin = create(:user, role: 2)

    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant, active?: false)
    @merchant3 = create(:merchant)

    @merchant1_user = create(:user, role: 1, merchant_id: @merchant1.id)
    @merchant2_user = create(:user, role: 1, merchant_id: @merchant2.id)
    @merchant3_user = create(:user, role: 1, merchant_id: @merchant3.id)


    visit '/login'
    within("#login-form")do
      fill_in :email, with: @admin.email
      fill_in :password, with: 'p123'
      click_button "Login"
    end
  end


  it "US38 Admin disables merchant account" do
    visit admin_merchants_path
    expect(current_path).to eq('/admin/merchants')

    within("#merchant-#{@merchant1.id}")do
      expect(page).to have_content(@merchant1.name)
      expect(page).to_not have_content(@merchant2.name)
      expect(page).to have_button("disable")
    end
    within("#merchant-#{@merchant2.id}")do
      expect(page).to have_content(@merchant2.name)
      expect(page).to_not have_content(@merchant1.name)
      expect(page).to_not have_button("disable")
    end
    within("#merchant-#{@merchant3.id}")do
      expect(page).to have_content(@merchant3.name)
      expect(page).to_not have_content(@merchant2.name)
      click_button("disable")
    end
    expect(current_path).to eq(admin_merchants_path)
    expect(page).to have_content("Merchant #{@merchant3.id} has been disabled")

  end
  

end