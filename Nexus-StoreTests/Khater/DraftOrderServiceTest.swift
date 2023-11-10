//
//  DraftOrderServiceTest.swift
//  Nexus-StoreTests
//
//  Created by Khater on 06/11/2023.
//

import XCTest
@testable import Nexus_Store

final class DraftOrderServiceTest: XCTestCase {
    
    let service = DraftOrderService()
    let customer = 6924053840108
    let variantID = 44007212220652
    
    func test_fetchCustomer() {
        let exp = expectation(description: "test_fetchCustomer")
        
        service.customerDraftOrder(customerID: customer) { result in
            switch result {
            case .success(let draftOrder):
                // Response is the actual customer
                XCTAssertEqual(draftOrder.customer.id, self.customer)
                exp.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func test_addNewLineItem() {
         let exp = expectation(description: "test_addNewLineItem")
        service.addNewLineItem(customerID: customer, variantID: variantID, quantity: 2, imageURLString: "") { error in
            if let error {
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 500)
    }
    
    func test_updateLineItemQuantity() {
        let exp = expectation(description: "test_updateLineItemQuantity")
        service.updateLineItemQuantity(customerID: customer, variantID: variantID, newQuantity: 1) { error in
            if let error {
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 500)
    }
    
    func test_deleteLineItem() {
        let exp = expectation(description: "test_deleteLineItem")
        service.deleteLineItem(customerID: customer, variantID: variantID) { error in
            if let error {
                XCTFail(error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
