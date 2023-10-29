//
//  Review.swift
//  Nexus-Store
//
//  Created by Mustafa on 27/10/2023.
//

import Foundation

struct AllReview{
    static var goodReview:[Review] = [
        Review(name: "Mustafa Adel", ratting: 5, date: "October 21, 2023", review: "I absolutely love this product! The quality is outstanding, and it exceeded my expectations. It's worth every penny."),
        Review(name: "Ayman Naim", ratting: 4, date: "Jan 12, 2023", review: "These clothes are incredibly comfortable and stylish. The fit is perfect, and the fabric feels great against the skin."),
        Review(name: "Ahmed Ashraf", ratting: 4, date: "July 3, 2023", review: "These shoes are amazing! They provide excellent support and cushioning, making them perfect for long walks or runs. Plus, they look fantastic!"),
        Review(name: "Mohamed Khater", ratting: 5, date: "May 28, 2023", review: "The product arrived earlier than expected, and the packaging was impeccable. The customer service was also top-notch. Highly recommended!"),
        Review(name: "Ahmed Adel", ratting: 4, date: "Feb 15, 2023", review: "I'm thrilled with the quality and durability of these clothes. They have held up well even after multiple washes. I'll definitely be buying more."),
    ]
    static var badReview:[Review] = [
        Review(name: "Adel Mustafa", ratting: 1, date: "October 21, 2023", review: "I'm disappointed with this product. The quality is subpar, and it didn't last long before falling apart. Definitely not worth the price."),
        Review(name: "Naim Ayman", ratting: 2, date: "Jan 12, 2023", review: "These clothes looked great initially, but after the first wash, they shrunk significantly. The sizing is way off, and now I can't wear them anymore."),
        Review(name: "Ashraf Ahmed", ratting: 2, date: "July 3, 2023", review: "These shoes are uncomfortable and poorly made. They caused blisters on my feet, and the sole started tearing within a week of use. I expected better."),
        Review(name: "Khater Mohamed", ratting: 1, date: "May 28, 2023", review: "The product didn't live up to the hype. The color faded quickly, and the stitching came undone. I wouldn't recommend it to others."),
        Review(name: "Adel Ahmed", ratting: 1, date: "Feb 15, 2023", review: "The customer service was terrible. I had an issue with the product, and it was impossible to reach anyone for assistance. It's a shame, as I liked the item."),
    ]
    
    
}

struct Review{
    
    let name:String
    let ratting:Double
    let date:String
    let review:String
    
   
}


