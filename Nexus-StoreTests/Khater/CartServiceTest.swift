//
//  CartServiceTest.swift
//  Nexus-StoreTests
//
//  Created by Khater on 06/11/2023.
//

import XCTest
@testable import Nexus_Store

final class CartServiceTest: XCTestCase {
    
    let service = CartService()
    let customer = 6924053840108
    let variantID = 44007212220652
    
    func test_addToCart() {
        let exp = expectation(description: "test_addToCart")
        service.addProductToCart(forCustomerID: customer, variantID: variantID, quantity: 2, imageURLString: "") { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                exp.fulfill()
                return
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_getCartProducts() {
        let exp = expectation(description: "test_getCartProducts")
        service.getCartProducts(forCustomerID: customer) { result in
            switch result {
            case .success(let products):
                XCTAssertFalse(products.isEmpty)
                exp.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }
    
    
    func test_getProductImage() {
        let exp = expectation(description: "test_updateQuantity")
        service.imageForProduct(withProductID: 8031031165164) { imageURL in
            XCTAssertFalse(imageURL.isEmpty)
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}
