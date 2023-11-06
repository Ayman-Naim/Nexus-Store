//
//  CartViewModelTest.swift
//  Nexus-StoreTests
//
//  Created by Khater on 06/11/2023.
//

import XCTest
@testable import Nexus_Store


final class CartViewModelTest: XCTestCase {
    let viewModel = CartViewModel(customerID: 6934235676908)
    
    func test_fetchCartProducts() {
        let exp = expectation(description: "test_fetchWishlistProducts")
        viewModel.reload = {
            XCTAssertGreaterThan(self.viewModel.numberOfRows, 0)
            exp.fulfill()
        }
        
        viewModel.errorOccure = { messae in
            XCTFail(messae)
            exp.fulfill()
        }
        viewModel.fetchCartProducts()
        waitForExpectations(timeout: 10)
    }
}
