require 'rails_helper'

RSpec.describe "Merchant items index page" do
  before :each do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @item100 = create(:item, merchant: @merchant1, price: 100)
    @item101 = create(:item, merchant: @merchant1, price: 101)
    @item102 = create(:item, merchant: @merchant1, price: 102)
    @item200 = create(:item, merchant: @merchant2, price: 200)
    @merchant_user = create(:user, name: "merchant user", role: 1, merchant_id: @merchant1.id)




    visit '/login'
    within("#login-form")do
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: 'p123'
      click_button "Login"
    end
    
  end
  


  it "US42 Merchant sees their items and can deactivate them " do
    visit merchant_items_path 

    expect(page).to_not have_content(@item200.name)

    within("#item-#{@item100.id}")do
      expect(page).to have_content("Name: #{@item100.name}")
      expect(page).to_not have_content("Name: #{@item101.name}")
      expect(page).to have_content("Description: #{@item100.description}")
      expect(page).to have_content("Price: $100.00")
      expect(page).to have_css("img[src*='#{@item100.image}']")
      expect(page).to have_content("Active? #{@item100.active?}")
      expect(page).to have_content("Inventory: #{@item100.inventory}")
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enable")
    end
    within("#item-#{@item101.id}")do
      expect(page).to have_content("Name: #{@item101.name}")
      expect(page).to_not have_content("Name: #{@item100.name}")
      expect(page).to have_content("Description: #{@item101.description}")
      expect(page).to have_content("Price: $101.00")
      expect(page).to have_css("img[src*='#{@item101.image}']")
      expect(page).to have_content("Active? #{@item101.active?}")
      expect(page).to have_content("Inventory: #{@item101.inventory}")
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enable")
    end
    within("#item-#{@item102.id}")do
      expect(page).to have_content("Name: #{@item102.name}")
      expect(page).to_not have_content("Name: #{@item101.name}")
      expect(page).to have_content("Description: #{@item102.description}")
      expect(page).to have_content("Price: $102.00")
      expect(page).to have_css("img[src*='#{@item102.image}']")
      expect(page).to have_content("Active? #{@item102.active?}")
      expect(page).to have_content("Inventory: #{@item102.inventory}")
      expect(page).to_not have_button("Enable")
      click_button("Disable")
    end
    expect(page).to have_content("You have disabled item #{@item102.id}")
    expect(current_path).to eq(merchant_items_path)
    within("#item-#{@item100.id}")do
      expect(page).to_not have_button("Enable")
      expect(page).to have_button("Disable")
      expect(page).to have_content("Active? true")
    end
    within("#item-#{@item101.id}")do
      expect(page).to_not have_button("Enable")
      expect(page).to have_button("Disable")
      expect(page).to have_content("Active? true")
    end
    within("#item-#{@item102.id}")do
      expect(page).to_not have_button("Disable")
      expect(page).to have_button("Enable")      
      expect(page).to have_content("Active? false")
    end
    
  end
  
  
end