//
//  CharityModelTests.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/19/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import XCTest
@testable import TamBoonKit

class CharityModelTests: XCTestCase {
  
  func testCreateCharityFromJSON() {
    let passedJSONData = [
      "id": 0, "name": "Ban Khru Noi", "logo_url": "http://rkdretailiq.com/news/img-corporate-baankrunoi.jpg"
    ]
    
    let expectedPassedCharity = Charity(passedJSONData)
    XCTAssertNotNil(expectedPassedCharity)
    XCTAssertEqual(expectedPassedCharity?.id, 0)
    XCTAssertEqual(expectedPassedCharity?.name, "Ban Khru Noi")
    
    let failedJSONData = [
      [ "id_no": 0, "name": "Ban Khru Noi" ],
      [ "id": 0, "name_no": "Ban Khru Noi" ]
    ]
    
    let firstExpectedFailedCharity = Charity(failedJSONData[0])
    XCTAssertNil(firstExpectedFailedCharity)
    let secondExpectedFailedCharity = Charity(failedJSONData[1])
    XCTAssertNil(secondExpectedFailedCharity)
  }
  
  func testCharityHashableConformance() {
    let firstExpectedEqualsCharity = Charity(id: 0, name: "First", logoURL: nil)
    let secondExpectedEqualsCharity = Charity(id: 0, name: "Second", logoURL: nil)
    
    XCTAssertEqual(firstExpectedEqualsCharity.id, secondExpectedEqualsCharity.id)
    XCTAssertEqual(firstExpectedEqualsCharity.hashValue, secondExpectedEqualsCharity.hashValue)
    XCTAssertEqual(firstExpectedEqualsCharity, secondExpectedEqualsCharity)
    
    let firstExpectedNotEqualsCharity = Charity(id: 0, name: "Charity", logoURL: nil)
    let secondExpectedNotEqualsCharity = Charity(id: 1, name: "Charity", logoURL: nil)
    
    XCTAssertNotEqual(firstExpectedNotEqualsCharity.id, secondExpectedNotEqualsCharity.id)
    XCTAssertNotEqual(firstExpectedNotEqualsCharity.hashValue
      , secondExpectedNotEqualsCharity.hashValue)
    XCTAssertNotEqual(firstExpectedNotEqualsCharity, secondExpectedNotEqualsCharity)
  }
  
  func testPaymentInformationHashableConformance() {
    let firstExpectedEqualsPaymentInformation = PaymentInformation(token: "token", amount: 200)
    let secondExpectedEqualsPaymentInformation = PaymentInformation(token: "token", amount: 200)
    
    XCTAssertEqual(firstExpectedEqualsPaymentInformation.token, secondExpectedEqualsPaymentInformation.token)
    XCTAssertEqual(firstExpectedEqualsPaymentInformation.amount, secondExpectedEqualsPaymentInformation.amount)
    XCTAssertEqual(firstExpectedEqualsPaymentInformation, secondExpectedEqualsPaymentInformation)
    
    let firstExpectedNotEqualsCharity = PaymentInformation(token: "token", amount: 200)
    let secondExpectedNotEqualsCharity = PaymentInformation(token: "token_no", amount: 200)
    let thirdExpectedNotEqualsCharity = PaymentInformation(token: "token", amount: 300)
    
    XCTAssertNotEqual(firstExpectedNotEqualsCharity, thirdExpectedNotEqualsCharity)
    XCTAssertNotEqual(secondExpectedNotEqualsCharity
      , thirdExpectedNotEqualsCharity)
    XCTAssertNotEqual(firstExpectedNotEqualsCharity, secondExpectedNotEqualsCharity)
  }
}
