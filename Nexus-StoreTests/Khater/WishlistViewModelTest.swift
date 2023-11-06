//
//  WishlistViewModelTest.swift
//  Nexus-StoreTests
//
//  Created by Khater on 06/11/2023.
//

import XCTest
@testable import Nexus_Store

final class WishlistViewModelTest: XCTestCase {
    
    let viewModel = WishListViewModel(customerID: 6934235676908)
    
    func test_fetchWishlistProducts(){
        let exp = expectation(description: "test_fetchWishlistProducts")
        viewModel.reload = {
            XCTAssertGreaterThan(self.viewModel.numberOfRow, 0)
            exp.fulfill()
        }
        
        viewModel.errorOccure = { messae in
            XCTFail(messae)
            exp.fulfill()
        }
        
        viewModel.fetchProducts()
        waitForExpectations(timeout: 10)
    }
    
}
