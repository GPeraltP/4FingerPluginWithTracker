//
//  VeridiumTXConfirmationViewController.swift
//  VeridiumAuthenticator
//
//  Created by Paul Paul on 2/23/18.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import VeridiumCore

public class VeridiumTXConfirmationViewController: UIViewController {
  
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var okButton: UIButton!
  @IBOutlet weak var dontAllowButton: UIButton!
  @IBOutlet weak var holderView: UIView!
  
  public var onOK:voidBlock? = nil
  public var onCancel:voidBlock? = nil
  
  static public func initiate(withMessage:String) -> VeridiumTXConfirmationViewController {
    let controller:VeridiumTXConfirmationViewController = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator")).instantiateViewController(withIdentifier: "VeridiumTXConfirmationViewController") as! VeridiumTXConfirmationViewController
    controller.loadView()
    controller.messageLabel.text = withMessage
    return controller
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.addShaddow(view: self.holderView)
    self.holderView.layer.cornerRadius = 15.0
    self.holderView.layer.masksToBounds = true
    self.messageLabel.adjustsFontSizeToFitWidth = true
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onOk(_ sender: Any) {
    self.dismiss(animated: true, completion: self.onOK)
  }
 
  @IBAction func onDontAllow(_ sender: Any) {
    self.dismiss(animated: true, completion: self.onCancel)
  }
}
