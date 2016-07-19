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
  
  var donatingAmount: Int = 0
  var isDonationValid: Bool {
    return tamBoonAPI != nil && donatingAmount >= 20
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
    showViewController(cardInputFormController, sender: self)
  }
  
  @IBAction func donateAmountDidChanged(sender: UITextField) {
    guard let updatedText = sender.text, let amount = Int(updatedText) else { return }
    
    self.donatingAmount = amount
  }
}

extension DonatingViewController: CreditCardFormDelegate {
  func creditCardForm(controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
    guard let tamBoonAPI = tamBoonAPI, charity = charity, tokenID = token.tokenId else { return }
    
    let window: UIView = controller.view.window ?? controller.view
    
    let submitDonationProgressView = MBProgressHUD(view: window)
    submitDonationProgressView.mode = .Indeterminate
    submitDonationProgressView.animationType = .Zoom
    submitDonationProgressView.removeFromSuperViewOnHide = true
    submitDonationProgressView.label.text = NSLocalizedString("donation.donating-inprogress", value: "Donating...", comment: "Title for donation is in progress splash scene") 
    submitDonationProgressView.backgroundView.style = MBProgressHUDBackgroundStyle.SolidColor
    submitDonationProgressView.backgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
    
    window.addSubview(submitDonationProgressView)
    submitDonationProgressView.showAnimated(true)
    
    tamBoonAPI.donateToCharity(charity, withDonatorName: token.card?.name ?? "", payment: PaymentInformation(token: tokenID, amount: self.donatingAmount * 100), completion: { (donatingError) in
      submitDonationProgressView.hideAnimated(true)
      if let error = donatingError {
        // Display error message to user.
        let errorMessage: String
        switch error {
        case .FoundationError(let error):
          errorMessage = error.localizedDescription
        case .HTTPError(_, message: let message?):
          print(message)
          fallthrough
        default:
          errorMessage = NSLocalizedString("donation.error.default-message", value: "An error occured.", comment: "A default error message")
        }
        
        let displayingErrorMessageFormat = NSLocalizedString("donation.error.displaying-message", value: "%@ Please try again later and don't worry you have not been charged yet.", comment: "A default displaying error in alert")
        let displayingMessage = String.localizedStringWithFormat(displayingErrorMessageFormat, errorMessage)
        let errorAlertController = UIAlertController(title: nil, message: displayingMessage, preferredStyle: .Alert)
        errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("common.ok", value: "OK", comment: "A default OK title"), style: UIAlertActionStyle.Cancel, handler: nil))
        controller.presentViewController(errorAlertController, animated: true, completion: nil)
      } else if let donationSucceedSplashViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DonationSplashViewController") as? DonationSplashViewController {
        donationSucceedSplashViewController.donatedCharity = self.charity
        controller.presentViewController(donationSucceedSplashViewController, animated: true, completion: nil)
      }
    })
  }
  
  func creditCardForm(controller: CreditCardFormController, didFailWithError error: ErrorType) {
    // We choose to let CreditCardFormController handles error.
  }
}


