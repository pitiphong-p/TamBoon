//
//  LicenseViewerViewController.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/19/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit

class LicenseViewerViewController: UIViewController {
  
  @IBOutlet weak var licenseContentTextView: UITextView! {
    didSet {
      licenseContentTextView.text = licenseContent
    }
  }
  var licenseContent: String? {
    didSet {
      licenseContentTextView?.text = licenseContent
    }
  }  
}
