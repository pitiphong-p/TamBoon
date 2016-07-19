//
//  TamBoonAPITests.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/19/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import XCTest
@testable import TamBoonKit


class TamBoonAPITests: XCTestCase {
    
  func testHostURL() {
    let hostURL = NSURL(string: "http://localhost:8080")!
    let tamBoonAPI = TamBoonAPI(host: hostURL)
    XCTAssertEqual(tamBoonAPI.host, hostURL)
  }
  
  func testTamBoonAPIErrorHashableConformance() {
    do {
      let firstExpectedEqualsError = TamBoonAPIError.HTTPError(200, message: "OK?")
      let secondExpectedEqualsError = TamBoonAPIError.HTTPError(200, message: "OK?")
    
      XCTAssertEqual(firstExpectedEqualsError, secondExpectedEqualsError)
    }
    
    do {
      let firstExpectedEqualsError = TamBoonAPIError.InvalidResponse
      let secondExpectedEqualsError = TamBoonAPIError.InvalidResponse
      
      XCTAssertEqual(firstExpectedEqualsError, secondExpectedEqualsError)
    }
    
    do {
      let error = NSError(domain: NSURLErrorDomain, code: 404, userInfo: nil)
      let firstExpectedEqualsError = TamBoonAPIError.FoundationError(error)
      let secondExpectedEqualsError = TamBoonAPIError.FoundationError(error)
      
      XCTAssertEqual(firstExpectedEqualsError, secondExpectedEqualsError)
    }
    
    do {
      let error = NSError(domain: NSURLErrorDomain, code: 404, userInfo: nil)
      let secondError = NSError(domain: NSCocoaErrorDomain, code: 404, userInfo: nil)
      let firstExpectedNotEqualsError = TamBoonAPIError.FoundationError(error)
      let secondExpectedNotEqualsError = TamBoonAPIError.FoundationError(secondError)
      
      XCTAssertNotEqual(firstExpectedNotEqualsError, secondExpectedNotEqualsError)
    }
    
    do {
      let firstExpectedNotEqualsError = TamBoonAPIError.HTTPError(404, message: "OK?")
      let secondExpectedNotEqualsError = TamBoonAPIError.HTTPError(400, message: "OK?")
      
      XCTAssertNotEqual(firstExpectedNotEqualsError, secondExpectedNotEqualsError)
    }
    
    do {
      let error = NSError(domain: NSURLErrorDomain, code: 404, userInfo: nil)
      let firstExpectedNotEqualsError = TamBoonAPIError.HTTPError(404, message: "OK?")
      let secondExpectedNotEqualsError = TamBoonAPIError.FoundationError(error)
      
      XCTAssertNotEqual(firstExpectedNotEqualsError, secondExpectedNotEqualsError)
    }
    
    do {
      let firstExpectedNotEqualsError = TamBoonAPIError.HTTPError(404, message: "OK?")
      let secondExpectedNotEqualsError = TamBoonAPIError.InvalidResponse
      
      XCTAssertNotEqual(firstExpectedNotEqualsError, secondExpectedNotEqualsError)
    }
    
    do {
      let error = NSError(domain: NSURLErrorDomain, code: 404, userInfo: nil)
      let firstExpectedNotEqualsError = TamBoonAPIError.InvalidResponse
      let secondExpectedNotEqualsError = TamBoonAPIError.FoundationError(error)
      
      XCTAssertNotEqual(firstExpectedNotEqualsError, secondExpectedNotEqualsError)
    }
  }
  
}
