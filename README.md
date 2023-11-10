# Nexus
<!-- Project Settings -->
![Xcode: Version](https://img.shields.io/badge/Xcode-14.3-lightgray?logo=Xcode)
![Swift: Version](https://img.shields.io/badge/Swift-5.8-lightgray?logo=Swift)
![iOS: Version](https://img.shields.io/badge/iOS-16.2+-lightgray) 
![Devices: iPhone & iPad](https://img.shields.io/badge/Devices-iPhone%20&%20iPad-lightgray)
![Interface: UIKit | SwiftUI](https://img.shields.io/badge/Interface-UIKit-lightgray)
![Architecture: MVC | MVVM | MVC](https://img.shields.io/badge/Architecture-MVVM-lightgray)



<!-- Main Screenshot -->
<p>
    <img src="Mockups/Hotpot 0.png" width="19%" />
    <img src="Mockups/Hotpot 1.png" width="19%" />
    <img src="Mockups/Hotpot 2.png" width="19%" />
    <img src="Mockups/Hotpot 3.png" width="19%" />
    <img src="Mockups/Hotpot 4.png" width="19%" />
</p>

<!-- Project bref -->
It is an E-Commerce Application that presents products from different vendors and enables the authenticated users to add/remove products to/from their shopping carts and complete the whole shopping cycle online through the app.



<!-- ____________________________________________________________________________ -->
## Table of Contents
 - [Features](#features)
 - [Technologies](#technologies)
 - [Dependencies](#dependencies)
 - [Demo Video](#demo-video)
 - [Screenshot](#screenshot)



<!-- ____________________________________________________________________________ -->
## Features 
### Nexus Store (User App)
- GuestMode
- CreateanaccountemailandpasswordorGoogleaccount
- Sign In with email and password or Google account
- Home
  - Userinformation(email) 2. ShowAllBrands
  - ShowCoupons
  - Search
- Category
  - Classifymaincategory(Men,Women,Kids,Sales)
  - Classify subcategory (All, T-Shirt, Shoes, Accessories)
  - Showproductdependingonmaincategoryandsubcategory
  - Filteringwithpriceandalphabetic
  - Search
- Profile
  - ShowUserinformation
  - Display Orders
  - DiplayWishlist
- Settings
  - AboutUS
  - ContactUS
  - ChangeCurrency
  - Display Address (delete and add new one)
  - SignOut
- ProductDetails
  - Diplays images for product
  - Showinformation(productname,brandtype,descrption)
  - Display Available quantity and color
  - Selectquantityaccordingtoavailability
  - AddtoCart
  - AddtoWishlist
  - ShowReviews
- Wishlist
  - Display wishlist products
  - Deleteproductfromwishlist
  - NavigatetoProductDetails
- Payment
  - Cart
    - Showallproductsthatuseradded
    - Display total price
    - Update product quantity according to availability
    - Deleteproductfromcart
  - ShippingAddress
    - Display User addresses
    - Addnewaddress
    - Select address for shipping
  - PromoCode
    - Check availability of the precence of discount code
    - Apply promo code on the order
    - Show orders to confirm payment
    - Gotopayprocess
  - Pay
    - Check the availability of the total amount in pocket
    - Choose payment methods (Cash on delivery, Apple Pay, PayPal)
    - Pay and Sending order information mail
      
### Nexus Admin 
- Home
  - Can display brands
  - Display Brand products
  - Display, Add, delete or edit products
  - Edit product Details include for example: size, color, quantity, name, images, details
  - Display, Add, delete or edit inventory items
  - Add products to specific Brand
- PromoCode
  - Display, Add, delete Promo code




<!-- ____________________________________________________________________________ -->
## Technologies

- Apple Pay
- Delegate Design Pattern
- Singleton Design Pattern



<!-- ____________________________________________________________________________ -->
## Dependencies
> Most of dependencies are installed using Cocoapods, and others installed using Swift Package Manager
- [Shopify API](https://shopify.dev/docs/api)
- [Alamofire](https://cocoapods.org/pods/Alamofire)
- [Kingfisher](https://cocoapods.org/pods/Kingfisher)
- [Lottie Animation](https://cocoapods.org/pods/lottie-ios)
- [Firebase](https://firebase.com/)
- [Google Sign in (SPM)](https://github.com/google/GoogleSignIn-iOS)

<!-- ____________________________________________________________________________ -->
## Demo Video

> Click on the image to show the demo video

<!-- Video Link -->
<a href="https://www.youtube.com/watch?v=btNdq8hYc9o">
    <!-- Video Image -->
    <img 
        src="https://img.youtube.com/vi/btNdq8hYc9o/0.jpg" 
        alt="Demo Video" 
        height="400"
    />
</a>



<!-- ____________________________________________________________________________ -->
## Screenshot

First Page | Second Page | Third Page
---------- | ----------- | ----------
![]() | ![]() | ![]()
![]() | ![]() | ![]()
![]() | ![]() | ![]()
