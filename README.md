# Monster Shop

#### Made from the blood, sweat, and tears of:

- [Mariana Cid](https://github.com/Mariana-21)
- [Ross Perry](https://github.com/perryr16)
- [Derek Borski](https://github.com/dborski)
- [Michelle Foley](https://github.com/foleymichelle9)

## Background and Description

"Monster Shop" is a fictitious e-commerce platform built by Turing School of Software Design's Backend Program students. This app allows you to shop for items ranging from bike parts to pet items. Not what you're looking for? No problem! Merchants can be created with their own unique items!

## Implementation Instructions

### To set up locally:

* Clone down the repository.
* Run `bundle install`.
* Run `rails db:{create,migrate,seed}` to setup the database.
* Run `rails s` and navigate your browser to `localhost:3000` to use the development database.


## Design Patterns:

* TDD (Test Driven Development)
* MVC (Model View Controller)
* CRUD Functionality (Create Read Update Destroy)
* ActiveRecord

## Gems:

* Orderly
* BCrypt
* Shoulda Matchers
* Capybara
* Factory Bot

## Dependencies

You must have the following to run this project:

* Rails 5.1.7
* Ruby 2.5.x
* Bundler version 2.0.1

## Authentication and Authorization

### Functionality By User Type
### Visitors

 `A visitor` to this website is classifed as anyone who is not currently logged in. Visitors can:

* Visit the index of merchants,
* Visit the index of items,
* Add items to a cart,
* View the cart,
* Both increase and decrease item quantity in cart, and;
* Can access both login and register routes.

 `A user` of this website has an account created with the site

*Before one can access user functionality, they must be registered to the site. Registration requires name, full address, unique email, and matching password fields in order to complete successfully.*

<img width="527" alt="register" src="https://user-images.githubusercontent.com/55991172/83781175-624a0e80-a64b-11ea-823e-ff23535969cb.png">

* As a User, you are able to register, login, add items to your cart and place the order.

A user can do all of the things a visitor can do, plus:

* User has a profile page which displays all user information (except password),
* Profile page has edit profile and change password option, and;
* If user has any open orders, they will have a "My Orders" link to view their orders.

A user's order index displays the following:

* Order ID,
* Number of items within the order,
* Status of the current order,
* Total cost of the order, and;
* Created and updated dates.

If a user clicks on their order ID, the order show page displays the following:

* Includes all of the above order information, plus;
* Breakdown by item, including name, image, price, quantity, description, and subtotal, and;
* If order has not been shipped, there is an option to cancel the order.

If a user would like to proceed with their finalized order, they have the ability to:

* Go to their cart, and;
* Have a checkout option that, once clicked, will empty their cart.

### Merchant Employee

A `merchant employee` of this website includes all of the same access as a user, plus:

#### Merchant Dashboard

<img width="660" alt="Screen Shot 2020-06-04 at 10 14 50 AM" src="https://user-images.githubusercontent.com/55991172/83782237-c4574380-a64c-11ea-85f9-a8b0f8e11080.png">

* Upon login, a merchant employee is directed to their merchant dashboard instead of user profile.

#### Displays merchant information including:
* The merchant that the employee works for.
* Displays open orders for items the merchant has:
* Each order displays an ID, total items for that merchant, total cost for that merchant, and the date the order was placed.
* Links to view item index for the merchant in question.

<img width="641" alt="Screen Shot 2020-06-04 at 10 15 22 AM" src="https://user-images.githubusercontent.com/55991172/83782254-cae5bb00-a64c-11ea-9a60-341b3d4e8058.png">

### Admin

An `admin` of this website has all of the same permissions as users except access to the cart

#### Admin Dashboard



<img width="621" alt="Screen Shot 2020-06-04 at 10 16 27 AM" src="https://user-images.githubusercontent.com/55991172/83782266-d0430580-a64c-11ea-9a1f-616d046d0777.png">


* Upon login, an admin is directed to the admin dashboard instead of user profile.
* This dashboard displays a breakdown of all orders which are sorted by packaged, pending, shipped, and cancelled.
* Each order has a link to the user who made the order, it's ID, when it was made, current status, and a link to ship the order if fully packaged.

## Logging Out

All types of users have access to logging out. When any type of user logs out, they are redirected to the home page. If there are any items in the cart, they are removed.

# Production Link

[Heroku](https://stark-sierra-04588.herokuapp.com/)  
