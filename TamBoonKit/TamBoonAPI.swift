//
//  TamBoonAPI.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import Foundation


public enum TamBoonAPIError: ErrorType {
  case HTTPError(Int)
  case foundationError(NSError)
  case invalidResponse
}

public class TamBoonAPI: NSObject {
  public let hostname: NSURL
  private var session: NSURLSession!
  private let processingQueue: NSOperationQueue = NSOperationQueue()
  
  public init(hostname: NSURL) {
    self.hostname = hostname
    super.init()
    session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
  }
  
  public func listAllCharities(completion: ([Charity]?, TamBoonAPIError?) -> Void) {
    let loadCharitiesTask = session.dataTaskWithURL(hostname, completionHandler: { (returnedData, response, error) in
      if let error = error {
        completion(nil, .foundationError(error))
        return
      }
      if let response = response as? NSHTTPURLResponse where !(200..<400 ~= response.statusCode) {
        completion(nil, .HTTPError(response.statusCode))
      }
      
      guard let data = returnedData else {
        completion(nil, .invalidResponse)
        return
      }
      
      let json: [[String: AnyObject]]
      do {
        if let parsedJSON = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]] {
          json = parsedJSON
        } else {
          throw TamBoonAPIError.invalidResponse
        }
      } catch {
        completion(nil, .invalidResponse)
        return
      }
      
      let charities = json.flatMap(Charity.init)
      completion(charities, nil)
    })
    loadCharitiesTask.resume()
  }
}


extension TamBoonAPI: NSURLSessionDelegate {
  
}

