//
//  AymanUnitTest.swift
//  Nexus-StoreTests
//
//  Created by Khater on 01/11/2023.
//

import XCTest
@testable import Nexus_Store
final class AymanUnitTest: XCTestCase {
    var HomeViewModel = HomeVM()
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
    //Home
    func testgetBrands(){
     
        HomeViewModel.getBrands {
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let brands ):
                XCTAssertNotNil(brands)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    func testgetPriceRole(){
     
        HomeViewModel.getPriceRole{
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let priceRole ):
                XCTAssertNotNil(priceRole)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    func testgetCouponescodes(){
        BaseUrl.priceRuleID = "-1"
        HomeViewModel.getCouponescodes{
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let copones ):
                XCTAssertNotNil(copones)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }

    
    func testgetPriceWithcoupouns(){
      
        HomeViewModel.getPriceWithcoupouns { bool in
            let expectaation = self.expectation(description: "waiting for the api")
            switch bool{
            case true :
                XCTAssertTrue(!self.HomeViewModel.CoupusOFPriceRule.isEmpty)
                expectaation.fulfill()
            case false :
                XCTFail()
                expectaation.fulfill()
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    
    
//Profile
    var ProfileViemodel = ProfileVM()
    func testgetOrders(){
       
        ProfileViemodel.getOrders{
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let orders ):
                XCTAssertNotNil(orders)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    func testgetWishlist(){
       
        ProfileViemodel.getWishlist(forCustom:0){
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let orders ):
                XCTAssertNotNil(orders)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    func testfetchAllMetafields(){
       
        ProfileViemodel.fetchAllMetafields(forCustom:0){
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let orders ):
                XCTAssertNotNil(orders)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    

  //Adresst Setting
    var AddressSettingVm = AdressSettingVM()
    

    func testgetUserAdresses(){
       
        AddressSettingVm.getUserAdresses{
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let orders ):
                XCTAssertNotNil(orders)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    
    func testDelteAdress(){
       
        AddressSettingVm.DelteAdress(addressID:0){
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let orders ):
                XCTAssertNotNil(orders)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    
    //add adress viemodel
    var AddAdressVM = AddAddressVM()
    func testaddAdress(){
       
        AddAdressVM.addAdress(name: "", city: "", adddress: "", Phone: ""){
            result in
            let expectaation = self.expectation(description: "waiting for the api")
            switch result{
            case .success(let orders ):
                XCTAssertNotNil(orders)
                expectaation.fulfill()
                
            case .failure(_):
                XCTFail()
                expectaation.fulfill()
                
            }
            self.waitForExpectations(timeout: 50000)
        }
    }
    
    
    
    

}
