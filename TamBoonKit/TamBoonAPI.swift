//
//  TamBoonAPI.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import Foundation

/// A payment information
public struct PaymentInformation {
  /// An Omise payment token generated by Omise SDK
  public let token: String
  /// An amount of donation in THB.
  public let amount: Int
  
  /// An initializer for the PaymentInformation
  public init(token: String, amount: Int) {
    self.token = token
    self.amount = amount
  }
}

/// The error information returned from TamBoon server
public enum TamBoonAPIError: ErrorType {
  /// An HTTP status error and error message (if given) returned from the server
  case HTTPError(Int, message: String?)
  /// An Foundation error returned from the iOS
  case FoundationError(NSError)
  /// An error indicated that server has returned an invalid or unknowned response data.
  case InvalidResponse
}

public class TamBoonAPI: NSObject {
  /// Based host of the *TamBoon* server
  public let host: NSURL
  private var session: NSURLSession!
  private let processingQueue: NSOperationQueue = NSOperationQueue()
  
  
  /**
   Create a new API instance with the given based host
   - parameter host: Based host for the newly created API
   */
  public init(host: NSURL) {
    self.host = host
    super.init()
    session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
  }
  

  /**
   List all of the available charities that are able to be donated to.
   - parameter completionQueue:  A dispatch queue that the completion callback will be dispatched on. Default queue is `main` queue.
   - parameter completion: A completion callback closure with 2 parameters, the returned charities list or an error that occured.
   */
  public func listAllCharitiesWith(completionQueue: dispatch_queue_t = dispatch_get_main_queue(), completion: ([Charity]?, TamBoonAPIError?) -> Void) {
    let loadCharitiesTask = session.dataTaskWithURL(host, completionHandler: { (returnedData, response, error) in
      let loadCharitiesError: TamBoonAPIError?
      let charities: [Charity]?
      defer {
        dispatch_async(completionQueue, { 
          completion(charities, loadCharitiesError)
        })
      }
      
      if let error = error {
        charities = nil
        loadCharitiesError = .FoundationError(error)
        return
      }
      if let response = response as? NSHTTPURLResponse where !(200..<400 ~= response.statusCode) {
        loadCharitiesError = .HTTPError(response.statusCode, message: returnedData.flatMap({ String(data: $0, encoding: NSUTF8StringEncoding) }))
        charities = nil
        return
      }
      
      guard let data = returnedData else {
        charities = nil
        loadCharitiesError = .InvalidResponse
        return
      }
      
      let json: [[String: AnyObject]]
      do {
        if let parsedJSON = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]] {
          json = parsedJSON
        } else {
          throw TamBoonAPIError.InvalidResponse
        }
      } catch {
        charities = nil
        loadCharitiesError = .InvalidResponse
        return
      }
      
      charities = json.flatMap(Charity.init)
      loadCharitiesError = nil
    })
    
    loadCharitiesTask.resume()
  }
  
  /**
   Donate to a specified charity with given donator name and payment information.
   - parameter charity: Charity that are going to be donated to.
   - parameter donatorName: A Name of the donator.
   - parameter payment: Donating payment information
   - parameter completionQueue: A dispatch queue that the completion callback will be dispatched on. Default queue is `main` queue.
   - parameter completion: A completion callback closure an occured error parameter. The error argument is nil if the donation operation is success.
   */
  public func donateToCharity(charity: Charity, withDonatorName name: String,
                              payment: PaymentInformation,
                              completionQueue: dispatch_queue_t = dispatch_get_main_queue(),
                              completion: (TamBoonAPIError?) -> Void) -> Void {
    let donateURL = host.URLByAppendingPathComponent("donate")
    let donatingRequest = NSMutableURLRequest(URL: donateURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
    donatingRequest.HTTPMethod = "POST"
    
    let donatingParameter = [
      "name": name,
      "token": payment.token,
      "amount": payment.amount
    ]
    
    let donatingPayload = try! NSJSONSerialization.dataWithJSONObject(donatingParameter, options: [])
    donatingRequest.HTTPBody = donatingPayload
    
    let donatingTask = session.dataTaskWithRequest(donatingRequest) { (returnedData, response, error) in
      let donationError: TamBoonAPIError?
      defer {
        dispatch_async(completionQueue, { 
          completion(donationError)
        })
      }
      
      if let error = error {
        donationError = .FoundationError(error)
        return
      }
      if let response = response as? NSHTTPURLResponse where !(200..<300 ~= response.statusCode) {
        donationError = .HTTPError(response.statusCode, message: returnedData.flatMap({ String(data: $0, encoding: NSUTF8StringEncoding) }))
        return
      }
      
      donationError = nil
    }
    
    donatingTask.resume()
  }
}


extension TamBoonAPI: NSURLSessionDelegate {
  
}

