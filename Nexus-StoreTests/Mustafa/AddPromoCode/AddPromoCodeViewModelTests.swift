//
//  AddPromoCodeViewModelTests.swift
//  Nexus-StoreTests
//
//  Created by Mustafa on 06/11/2023.
//

import XCTest
@testable import Nexus_Store
final class AddPromoCodeViewModelTests: XCTestCase {

    
    var addPromoCodeViewModel = AddPromoCodeViewModel()
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
    
    
    func testFetchDataOfPriceRule() {
        
        
        let expectaation = self.expectation(description: "waiting for the api")
        addPromoCodeViewModel.checkUsageOfCoponusAvaliable { bool in
            
            XCTAssertTrue(bool, "The usage of Copoun not expire")
            expectaation.fulfill()
        }
        
        waitForExpectations(timeout: 50000)
      }
      
    
    
    func testDiscountCopunt(){
        
        let expectaation = self.expectation(description: "waiting for the api")
        addPromoCodeViewModel.getDiscountCopoune { check, error in
            
            if check != nil {
                XCTAssertTrue((check != nil), "The Discount  Copoun not expire")
                expectaation.fulfill()

            }
            if error != nil{
                XCTAssertTrue((error != nil), "The Discount  Copoun not expire")
                expectaation.fulfill()
            }
           
           
        }
        waitForExpectations(timeout: 50000)

    }
    
    
    
   

}
