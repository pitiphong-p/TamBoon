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
  
  @IBOutlet weak var refreshListControl: UIRefreshControl!
  var charities: [Charity] = [] {
    didSet {
      if isViewLoaded() {
        tableView.reloadData()
      }
    }
  }
  var tamBoonAPI: TamBoonAPI? {
    didSet {
      refreshCharitiesList()
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
  
  private func refreshCharitiesList() {
    navigationItem.prompt = nil
    tamBoonAPI?.listAllCharitiesWith(completion: { [weak self] (charities, error) in
      guard let this = self else { return }
      
      this.refreshListControl.endRefreshing()
      if let charities = charities {
        this.charities = charities
      } else if error != nil {
         this.navigationItem.prompt = NSLocalizedString("charities-list.can't-load-charities.promt", value: "Can't load charities list, please try again later", comment: "A prompt displayed to user when cannot load the charities list from server")
      }
      })
  }
  
  @IBAction func refreshCharitiesList(sender: UIRefreshControl) {
    refreshCharitiesList()
  }
  
  @IBAction func cancelDonation(sender: UIStoryboardSegue) {}
  @IBAction func donationFinished(sender: UIStoryboardSegue) {}
  @IBAction func readingAboutFinished(sender: UIStoryboardSegue) {}
}


class CharityCell: UITableViewCell {
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var charityNameLabel: UILabel!
}

