require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to have_link(@dog_bone.merchant.name)
    end

    it "I can see a list of all active items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
    end
  end
  describe "When I visit the items index page" do
    before(:each) do
      @item1 = create(:item, name: "item1")
      @item2 = create(:item, name: "item2", active?: false)
      @item3 = create(:item, name: "item3")
      @item4 = create(:item, name: "item4")
      @item5 = create(:item, name: "item5")
      @item6 = create(:item, name: "item6")
      @item7 = create(:item, name: "item7")
      @item8 = create(:item, name: "item8")

      @order1 = create(:order)      
      @order2 = create(:order)      
      @order3 = create(:order)      
      @order4 = create(:order)      
      @order5 = create(:order)       

      ItemOrder.create(order: @order1, item: @item1, price: 5, quantity: 20)
      ItemOrder.create(order: @order1, item: @item4, price: 5, quantity: 15)
      ItemOrder.create(order: @order2, item: @item1, price: 5, quantity: 2)
      ItemOrder.create(order: @order2, item: @item3, price: 5, quantity: 6)
      ItemOrder.create(order: @order3, item: @item3, price: 5, quantity: 6)
      ItemOrder.create(order: @order4, item: @item6, price: 5, quantity: 6)
      ItemOrder.create(order: @order4, item: @item6, price: 5, quantity: 1)
      ItemOrder.create(order: @order4, item: @item7, price: 5, quantity: 5)
      ItemOrder.create(order: @order5, item: @item8, price: 5, quantity: 3)

      visit '/items'
      
    end

    it "displays the top 5 most popular items along with the quantity purchased" do

      within('#most-popular-items') do
        expect(@item1.name).to appear_before(@item4.name)
        expect(@item4.name).to appear_before(@item3.name)
        expect(@item3.name).to appear_before(@item6.name)
        expect(@item6.name).to appear_before(@item7.name)
      end
    end 
    it "displays the top 5 most popular items along with the quantity purchased" do

      within("#least-popular-items") do
        expect(@item8.name).to appear_before(@item7.name)
        expect(@item7.name).to appear_before(@item6.name)
        expect(@item6.name).to appear_before(@item3.name)
        expect(@item3.name).to appear_before(@item4.name)
      end 
    end 
  end
end
