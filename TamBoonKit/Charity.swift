//
//  Charity.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import Foundation

public struct Charity {
  public let id: Int
  public let name: String
  public let logoURL: NSURL?
}

extension Charity {
  init?(_ apiData: [String: AnyObject]) {
    guard let id = apiData["id"] as? Int, name = apiData["name"] as? String else {
      return nil
    }
    
    let logoURLString = apiData["logo_url"] as? String
    self.id = id
    self.name = name
    self.logoURL = logoURLString.flatMap(NSURL.init(string:))
  }
}


public func ==(lhs: Charity, rhs: Charity) -> Bool {
  return lhs.id == rhs.id
}

extension Charity: Hashable {
  public var hashValue: Int {
    return ~id.hashValue
  }
}
