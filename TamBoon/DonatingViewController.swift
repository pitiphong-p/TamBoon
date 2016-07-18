//
//  DonatingViewController.swift
//  TamBoon
//
//  Created by Pitiphong Phongpattranont on 7/18/2559 BE.
//  Copyright © 2559 Pitiphong Phongpattranont. All rights reserved.
//

import UIKit
import OmiseSDK
import TamBoonKit


class DonatingViewController: UIViewController {

  var charity: Charity? {
    didSet {
      updateCharityUI()
    }
  }
  var tamBoonAPI: TamBoonAPI?
  
  @IBOutlet weak var charityLogoImageView: UIImageView!
  @IBOutlet weak var charityNameLabel: UILabel!
  @IBOutlet weak var donateAmountTextField: UITextField!
 
  @IBOutlet weak var nextStepBarButtonItem: UIBarButtonItem!
  @IBOutlet var cancelCardInputFormButton: UIBarButtonItem!
  
  var donatingAmount: Int = 0
  var isDonationValid: Bool {
    return tamBoonAPI != nil && donatingAmount >= 2000
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateCharityUI()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func updateCharityUI() {
    guard isViewLoaded() else { return }
    
    charityNameLabel.text = charity?.name
    if let logoURL = charity?.logoURL {
      charityLogoImageView.sd_setImageWithURL(logoURL)
    }
  }
  
  @IBAction func proceedNextStep(sender: UIBarButtonItem) {
    let cardInputFormController = CreditCardFormController(publicKey: "pkey_test_54oojsyhv5uq1kzf4g4")
    cardInputFormController.delegate = self
    cardInputFormController.handleErrors = true
    cardInputFormController.navigationItem.leftBarButtonItem = cancelCardInputFormButton
    
    let cardInputFormWithNavigationController = UINavigationController(rootViewController: cardInputFormController)
    
    presentViewController(cardInputFormWithNavigationController, animated: true, completion: nil)
  }
  
  @IBAction func donateAmountDidChanged(sender: UITextField) {
    guard let updatedText = sender.text, let amount = Int(updatedText) else { return }
    
    self.donatingAmount = amount
  }
  
  @IBAction func cancelCardInputForm(sender: UIBarButtonItem) {
    if let presentedViewController = presentedViewController as? UINavigationController
      where presentedViewController.topViewController is CreditCardFormController  {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
}

extension DonatingViewController: CreditCardFormDelegate {
  func creditCardForm(controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
    guard let tamBoonAPI = tamBoonAPI, charity = charity, tokenID = token.tokenId else { return }
    
    tamBoonAPI.donateToCharity(charity, withDonatorName: "", payment: PaymentInformation(token: tokenID, amount: donatingAmount), completion: { (donatingError) in
      self.dismissViewControllerAnimated(true, completion: nil)
    })
  }
  
  func creditCardForm(controller: CreditCardFormController, didFailWithError error: ErrorType) {
    
  }
}


