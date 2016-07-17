//
//  TamBoonAPI.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import Foundation


public enum TamBoonAPIError: ErrorProtocol {
  case HTTPError(Int)
  case foundationError(NSError)
  case invalidResponse
}

public class TamBoonAPI: NSObject {
  public let hostname: URL
  private var session: URLSession!
  private let processingQueue: OperationQueue = OperationQueue()
  
  public init(hostname: URL) {
    self.hostname = hostname
    super.init()
    session = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  public func listAllCharities(completion: ([Charity]?, TamBoonAPIError?) -> Void) {
    let loadCharitiesTask = session.dataTask(with: hostname) { (returnedData, response, error) in
      if let error = error {
        completion(nil, .foundationError(error))
        return
      }
      if let response = response as? HTTPURLResponse where !(200..<400 ~= response.statusCode) {
        completion(nil, .HTTPError(response.statusCode))
      }
      
      guard let data = returnedData else {
        completion(nil, .invalidResponse)
        return
      }
      
      let json: [[String: AnyObject]]
      do {
        if let parsedJSON = try JSONSerialization.jsonObject(with: data) as? [[String: AnyObject]] {
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
    }
    loadCharitiesTask.resume()
  }
}


extension TamBoonAPI: URLSessionDelegate {
  
}

