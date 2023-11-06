//
//  WishlistServiceTest.swift
//  Nexus-StoreTests
//
//  Created by Khater on 06/11/2023.
//

import XCTest
@testable import Nexus_Store

final class WishlistServiceTest: XCTestCase {
    
    let service = WishListService()
    let customer = 6934235676908
    
    func test_getWishlistProduct() {
        let exp = expectation(description: "test_getWishlistProduct")
        service.getWishlist(forCustom: customer) { result in
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
    
    func test_addToWishlist() {
        let exp = expectation(description: "test_addToWishlist")
        service.addToWishList(productID: 8031031787756, toCustomer: customer) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                exp.fulfill()
                return
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func test_removeFromWishlist() {
        let exp = expectation(description: "test_removeFromWishlist")
        service.removeWishList(productID: 8031031787756, fromCustomer: customer) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
                exp.fulfill()
                return
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
