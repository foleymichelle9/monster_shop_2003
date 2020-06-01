# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Order.destroy_all
ItemOrder.destroy_all
Item.destroy_all
User.destroy_all
#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
computer_shop = Merchant.create(name: "Zed's Computers", address: '125 Computer St.', city: 'Denver', state: 'CO', zip: 80210)
merchant1 = Merchant.create(name: "M-N-1", address: 'A1', city: 'C1', state: 'S1', zip: 11111)
merchant2 = Merchant.create(name: "M-N-2", address: 'A2', city: 'C2', state: 'S2', zip: 11111)
merchant3 = Merchant.create(name: "M-N-3", address: 'A3', city: 'C3', state: 'S3', zip: 11111)
merchant4 = Merchant.create(name: "M-N-4", address: 'A4', city: 'C4', state: 'S4', zip: 11111)
merchant5 = Merchant.create(name: "M-N-5", address: 'A5', city: 'C5', state: 'S5', zip: 11111)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
#computer_shop items
laptop = computer_shop.items.create(name: "Laptop", description: "Fastest computer around!", price: 1000, image: "https://pisces.bbystatic.com/image2/BestBuy_US/images/products/6356/6356671_sd.jpg", inventory: 20)
keyboard = computer_shop.items.create(name: "Keyboard", description: "Bluetooth keyboard", price: 50, image: "https://images-na.ssl-images-amazon.com/images/I/81PLqxtrJ3L._AC_SL1500_.jpg", inventory: 15)
mouse = computer_shop.items.create(name: "Mouse", description: "Bluetooth mouse", price: 40, image: "https://www.staples-3p.com/s7/is/image/Staples/s1020457_sc7?wid=512&hei=512", inventory: 13)
# #merchant1 items
item101 = merchant1.items.create(name: "I-N-1", description: "I-D-1", price: 101, image:"http://placehold.it/120x120&text=image1", inventory: 100)
#merchant2 items
item201 = merchant2.items.create(name: "I-N-2", description: "I-D-2", price: 201, image:"http://placehold.it/120x120&text=image2", inventory: 202)
item202 = merchant2.items.create(name: "I-N-2", description: "I-D-2", price: 202, image:"http://placehold.it/120x120&text=image3", inventory: 202)
#merchant3 items
item301 = merchant3.items.create(name: "I-N-3", description: "I-D-3", price: 301, image:"http://placehold.it/120x120&text=image4", inventory: 301)
item302 = merchant3.items.create(name: "I-N-3", description: "I-D-3", price: 302, image:"http://placehold.it/120x120&text=image5", inventory: 302)
#merchant3 items
item401 = merchant4.items.create(name: "I-N-4", description: "I-D-4", price: 401, image:"http://placehold.it/120x120&text=image6", inventory: 401)
item402 = merchant4.items.create(name: "I-N-4", description: "I-D-4", price: 402, image:"http://placehold.it/120x120&text=image7", inventory: 402)
item402 = merchant4.items.create(name: "I-N-4", description: "I-D-4", price: 402, image:"http://placehold.it/120x120&text=image8", inventory: 402)








#Users
regular1 = User.create!(name: "User Name", address: "user address", city: "user city", state: "state", zip: "user zip", email: "user", password: "user", role: 0)
regular2 = User.create!(name: "User Name2", address: "user address2", city: "user city", state: "state", zip: "user zip", email: "user2", password: "user2", role: 0)
merchant1 = User.create!(name: "Merchant Name", address: "merchant address", city: "merchant city", state: "state", zip: "merchant zip", email: "merchant", password: "merchant", role: 1)
admin1 = User.create!(name: "Admin Name", address: "admin address", city: "admin city", state: "state", zip: "admin zip", email: "admin", password: "admin", role: 2)
#Orders
order1 = Order.create(name: "User Name", address: "Address 1", city: "City 1", state: "State 1", zip: 11111, user_id: regular1.id)      
order2 = Order.create(name: "User Name2", address: "Address 2", city: "City 2", state: "State 2", zip: 22222, user_id: regular2.id)      
#item_orders
item_order1 = ItemOrder.create(order: order1, item: tire, price: tire.price, quantity: 11)
item_order2 = ItemOrder.create(order: order1, item: pull_toy, price: pull_toy.price, quantity: 12)
item_order3 = ItemOrder.create(order: order1, item: dog_bone, price: dog_bone.price, quantity: 13)
item_order4 = ItemOrder.create(order: order2, item: laptop, price: laptop.price, quantity: 1)
item_order5 = ItemOrder.create(order: order2, item: tire, price: tire.price, quantity: 2)
item_order6 = ItemOrder.create(order: order2, item: keyboard, price: keyboard.price, quantity: 2)