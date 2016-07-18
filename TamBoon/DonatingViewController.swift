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
import MBProgressHUD


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

    dismissViewControllerAnimated(true, completion: { success in
      let window: UIView = self.view.window ?? self.view
      
      let submitDonationProgressView = MBProgressHUD(view: window)
      submitDonationProgressView.mode = .Indeterminate
      submitDonationProgressView.animationType = .Zoom
      submitDonationProgressView.removeFromSuperViewOnHide = true
      submitDonationProgressView.label.text = "Donating..."
      submitDonationProgressView.backgroundView.style = MBProgressHUDBackgroundStyle.SolidColor
      submitDonationProgressView.backgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
      
      window.addSubview(submitDonationProgressView)
      submitDonationProgressView.showAnimated(true)
      
      tamBoonAPI.donateToCharity(charity, withDonatorName: token.card?.name ?? "", payment: PaymentInformation(token: tokenID, amount: self.donatingAmount), completion: { (donatingError) in
        submitDonationProgressView.hideAnimated(true)
      })
    })
  }
  
  func creditCardForm(controller: CreditCardFormController, didFailWithError error: ErrorType) {
    
  }
}


