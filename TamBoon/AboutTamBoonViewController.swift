//
//  AboutTamBoonViewController.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/19/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit

class AboutTamBoonViewController: UITableViewController {
  
  @IBOutlet weak var tableViewHeaderView: UIView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let headerViewSize = tableViewHeaderView.systemLayoutSizeFittingSize(
      CGSize(width: view.bounds.width, height: UILayoutFittingCompressedSize.height),
      withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityFittingSizeLevel)
    
    tableViewHeaderView.frame.size = headerViewSize
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let licenseFileName: String
    switch segue.identifier {
    case "OpenOmiseLicense"?:
      licenseFileName = "Omise"
    case "OpenSDWebImageLicense"?:
      licenseFileName = "SDWebImage"
    case "OpenMBProgressHUDLicense"?:
      licenseFileName = "MBProgressHUD"
    default:
      return
    }
    
    let mainBundle = NSBundle.mainBundle()
    if let licenseFileURL = mainBundle.URLForResource(licenseFileName, withExtension: nil),
      license = try? String(contentsOfURL: licenseFileURL, encoding: NSUTF8StringEncoding),
      licenseViewerViewController = segue.destinationViewController as? LicenseViewerViewController {
      licenseViewerViewController.licenseContent = license
      
      licenseViewerViewController.title = (sender as? UITableViewCell)?.textLabel?.text
    }
  }
}
