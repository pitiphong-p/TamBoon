//: Playground - noun: a place where people can play

import UIKit
import TamBoonKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true

let tamBoonAPI = TamBoonAPI(hostname: URL(string: "http://localhost:8080")!)
tamBoonAPI.listAllCharities { (charities, error) in
  print(error)
  print(charities)
}


