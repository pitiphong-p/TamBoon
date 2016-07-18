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
        updateThankyouMessage()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateThankyouMessage()
  }
  
  private func updateThankyouMessage() {
    guard isViewLoaded(), let donatedCharity = donatedCharity else {
      return
    }
    
    let thankyouMessageFormat = NSLocalizedString("thankyou-splash.thankyou.message", value: "You have successfully donated to %@ Charity. Thank you.", comment: "A thank you message display to user when user made a successfully donation")
    thankyouLabel.text = String.localizedStringWithFormat(thankyouMessageFormat, donatedCharity.name)
  }
  
}
