//
//  ProductDetailsViewModelTests.swift
//  Nexus-StoreTests
//
//  Created by Mustafa on 06/11/2023.
//

import XCTest

@testable import Nexus_Store

final class ProductDetailsViewModelTests: XCTestCase {
    var productId = 8031031787756
    var customerID = 6934535831788
    var productDetailsView = ProductDetailsViewModel(for: 8031031787756)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testInit() {
           let productId = 8031031787756

           let viewModel = ProductDetailsViewModel(for: productId)

           XCTAssertEqual(viewModel.ProductId, productId)
       }
    
    func testpriceOfSingleItem(){
        
        
        let loadingAnimationExpectation = expectation(description: "Loading animation expectation")
        productDetailsView.isLoadingAnimation = { isLoading in
            if isLoading {
                loadingAnimationExpectation.fulfill()
            }
        }
            productDetailsView.priceOfSingleProduct()
            waitForExpectations(timeout: 1.0, handler: nil)

    }
    
    
    func testFavorteCustomerProduct(){
        
        let loadingAnimationExpectation = expectation(description: "Loading animation expectation")
        productDetailsView.isLoadingAnimation = { isLoading in
            if isLoading {
                loadingAnimationExpectation.fulfill()
            }
        }
            productDetailsView.checkCustomerFavoriteProduct(for: customerID)
            waitForExpectations(timeout: 1.0, handler: nil)
    }
   


}
