//
//  AppDelegate.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit

import TamBoonKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    let tamBoonAPI = TamBoonAPI(host: NSURL(string: "http://localhost:8080")!)
    if let charitiesListNavigationController = self.window?.rootViewController as? UINavigationController,
      charitiesListTableViewController = charitiesListNavigationController.topViewController as? CharityListTableViewController {
      charitiesListTableViewController.tamBoonAPI = tamBoonAPI
    }
    
    return true
  }
}

