//: Playground - noun: a place where people can play

import UIKit
import TamBoonKit
import XCPlayground


XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let tamBoonAPI = TamBoonAPI(hostname: NSsURL(string: "http://localhost:8080")!)
tamBoonAPI.listAllCharities { (charities, error) in
  print(error)
  print(charities)
}


