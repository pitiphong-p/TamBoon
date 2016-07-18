//
//  CharityListTableViewController.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit

import TamBoonKit
import WebImage


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
    SDImageCache.sharedImageCache().clearMemory()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "OpenDonatingScene",
      let donatingViewControllerWithNavigation = segue.destinationViewController as? UINavigationController,
      donatingViewController = donatingViewControllerWithNavigation.topViewController as? DonatingViewController,
      cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell ){
      let donatingCharity = charities[indexPath.row]
      donatingViewController.charity = donatingCharity
      donatingViewController.tamBoonAPI = tamBoonAPI
    }
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return charities.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CharityCell", forIndexPath: indexPath) as! CharityCell
    
    let charity = charities[indexPath.row]
    cell.charityNameLabel.text = charity.name
    if let logoURL = charity.logoURL {
      cell.logoImageView?.sd_setImageWithURL(logoURL)
    }
    
    return cell
  }
  
  
  @IBAction func cancelDonation(sender: UIStoryboardSegue) {}
  @IBAction func donationFinished(sender: UIStoryboardSegue) {}
  
}


class CharityCell: UITableViewCell {
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var charityNameLabel: UILabel!
}

