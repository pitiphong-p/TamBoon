//
//  CharityListTableViewController.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit

import TamBoonKit

class CharityListTableViewController: UITableViewController {
  
  var charities: [Charity] = [] {
    didSet {
      if isViewLoaded() {
        tableView.reloadData()
      }
    }
  }
  var tamBoonAPI: TamBoonAPI? {
    didSet {
      tamBoonAPI?.listAllCharitiesWith(completion: { [weak self] (charities, error) in
        guard let this = self else { return }
        
        if let charities = charities {
          this.charities = charities
        }
      })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return charities.count
  }
  
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CharityCell", forIndexPath: indexPath)
   
    let charity = charities[indexPath.row]
    cell.textLabel?.text = charity.name
    
    return cell
   }

}
