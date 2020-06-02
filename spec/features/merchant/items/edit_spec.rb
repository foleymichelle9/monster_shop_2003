require 'rails_helper'

RSpec.describe "Merchant Edit Item Page" do

  before :each do
    @merchant1 = create(:merchant)
    @merchant_user = create(:user, name: "merchant user", role: 1, merchant_id: @merchant1.id)

    @item100 = create(:item, merchant: @merchant1, price: 100, active?: false)
    @item101 = create(:item, merchant: @merchant1, price: 101)

    visit '/login'
    within("#login-form")do
      fill_in :email, with: @merchant_user.email
      fill_in :password, with: 'p123'
      click_button "Login"
    end

  end
  it "US47 Part I Merchant can edit an item with active true" do
    visit merchant_items_path


    within("#item-#{@item100.id}")do
      expect(page).to have_content(@item100.name)
      expect(page).to have_link("Edit")
    end
    within("#item-#{@item101.id}")do
      expect(page).to have_content(@item101.name)
      expect(page).to have_content("Active? true")
      click_link("Edit")
    end

    expect(current_path).to eq("/merchant/items/#{@item101.id}/edit")
    expect(current_path).to eq(edit_merchant_item_path(@item101))

    expect(find_field("item[name]").value).to eq(@item101.name)
    expect(find_field("item[description]").value).to eq(@item101.description)
    expect(find_field("item[image]").value).to eq(@item101.image)
    expect(find_field("item[price]").value).to eq("#{@item101.price}")
    expect(find_field("item[inventory]").value).to eq("#{@item101.inventory}")
    
    within("#edit-item-form")do
      fill_in "item[name]", with: "n2"
      fill_in "item[description]", with: "d2"
      fill_in "item[image]", with: ""
      fill_in "item[price]", with: "101"
      fill_in "item[inventory]", with: "11"

      click_on "Update Item"
    end

    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("Item #{@item101.id} has been updated")

    within("#item-#{@item101.id}")do
      expect(page).to have_content("Name: n2")
      expect(page).to have_content("Description: d")
      expect(page).to have_css("img[src*='https://www.pngitem.com/pimgs/m/187-1877177_packaging-box-opened-outline-box-outline-hd-png.png']")
      expect(page).to have_content("Price: $101.00")
      expect(page).to have_content("Inventory: 11")
      expect(page).to have_content("Active? true")
      expect(page).to have_link("Edit")
    end


  end
  it "US47 part II Merchant can edit an item with active false" do
    visit merchant_items_path


    within("#item-#{@item100.id}")do
      expect(page).to have_content(@item100.name)
      click_link("Edit")
    end


    expect(current_path).to eq("/merchant/items/#{@item100.id}/edit")
    expect(current_path).to eq(edit_merchant_item_path(@item100))

    expect(find_field("item[name]").value).to eq(@item100.name)
    expect(find_field("item[description]").value).to eq(@item100.description)
    expect(find_field("item[image]").value).to eq(@item100.image)
    expect(find_field("item[price]").value).to eq("#{@item100.price}")
    expect(find_field("item[inventory]").value).to eq("#{@item100.inventory}")
    
    within("#edit-item-form")do
      fill_in "item[name]", with: "n2"
      fill_in "item[description]", with: "d2"
      fill_in "item[image]", with: ""
      fill_in "item[price]", with: "101"
      fill_in "item[inventory]", with: "11"

      click_on "Update Item"
    end

    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("Item #{@item100.id} has been updated")

    within("#item-#{@item100.id}")do
      expect(page).to have_content("Name: n2")
      expect(page).to have_content("Description: d")
      expect(page).to have_css("img[src*='https://www.pngitem.com/pimgs/m/187-1877177_packaging-box-opened-outline-box-outline-hd-png.png']")
      expect(page).to have_content("Price: $101.00")
      expect(page).to have_content("Inventory: 11")
      expect(page).to have_content("Active? false")
      expect(page).to have_link("Edit")
    end
  end

  it "US48 cannot edit item if details are bad or missing" do
    visit edit_merchant_item_path(@item100)

     within("#edit-item-form")do
      fill_in "item[name]", with: "name1"
      fill_in "item[description]", with: ""
      fill_in "item[image]", with: ""
      fill_in "item[price]", with: ""
      fill_in "item[inventory]", with: ""

      click_on "Update Item"
    end

    expect(page).to have_content("You must enter a valid description, price, inventory")
    expect(current_path).to eq(edit_merchant_item_path(@item100))

    # expect(find_field("item[name]").value).to eq("name1")
    # expect(find_field("item[description]").value).to eq("")


  end
  
end
