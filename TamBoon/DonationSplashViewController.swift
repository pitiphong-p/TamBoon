//
//  DonationSplashViewController.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/19/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit
import TamBoonKit


class DonationSplashViewController: UIViewController {

  @IBOutlet weak var thankyouLabel: UILabel!
  
  var donatedCharity: Charity? {
    didSet {
      if isViewLoaded() {
        
      }
    }
  }
  
  private func updateThankyouMessage() {
    guard isViewLoaded(), let donatedCharity = donatedCharity else {
      return
    }
    
    thankyouLabel.text = "You have successfully donated to \(donatedCharity.name) Charity. Thank you."
  }
  
}
