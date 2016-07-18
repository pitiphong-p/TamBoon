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
}
