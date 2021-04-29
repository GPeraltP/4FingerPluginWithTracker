//
//  TOTPEnrollerViewController.swift
//  VeridiumOrchestrator
//
//  Created by Vlad Hudea on 23/03/2020.
//  Copyright © 2020 Veridium IP Ltd. All rights reserved.
//

import UIKit

class TOTPEnrollerViewController: UITableViewController, UIAdaptivePresentationControllerDelegate, Storyboarded {
    
    @objc public var successClosure: ((_ pin: String) -> ())?
    @objc public var cancelClosure: (() -> ())?
    
    @objc public var totpTitle: String?
    @objc public var totpPageDescription: String?
    @objc public var totpPinLength: UInt = 4
    @objc public var totpPinType: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pageDescription: UILabel!
    @IBOutlet weak var pin1TextField: UITextField!
    @IBOutlet weak var separator1View: UIView!
    @IBOutlet weak var pin2TextField: UITextField!
    @IBOutlet weak var separator2View: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    fileprivate let enabledColor: UIColor = UIColor.init(red: 52/255, green: 192/255, blue: 205/255, alpha: 1)
    fileprivate let disabledColor: UIColor = UIColor.lightGray
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        pin1TextField.resignFirstResponder()
        pin2TextField.resignFirstResponder()
        
        if let closure = successClosure, let pinString = pin1TextField.text {
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    closure(pinString)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        pin1TextField.resignFirstResponder()
        pin2TextField.resignFirstResponder()
        
        if let closure = cancelClosure {
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    closure()
                }
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pin1TextField.delegate = self
        pin2TextField.delegate = self
        self.titleLabel.text = totpTitle
        self.pageDescription.text = totpPageDescription
        separator1View.backgroundColor = self.disabledColor
        separator2View.backgroundColor = self.disabledColor
        
        switch totpPinType {
            case "number":
                pin1TextField.keyboardType = .numberPad
                pin2TextField.keyboardType = .numberPad
            case "string":
                pin1TextField.keyboardType = .asciiCapable
                pin2TextField.keyboardType = .asciiCapable
            default:
                pin1TextField.keyboardType = .asciiCapable
                pin2TextField.keyboardType = .asciiCapable
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentationController?.delegate = self
        pin1TextField.placeholder = L10n.veridiumSdkDigitPin(Int(totpPinLength))
        pin2TextField.placeholder = L10n.veridiumSdkDigitPinConfirm(Int(totpPinLength))
        doneButton.cornerRadius = doneButton.bounds.height / 2
        doneButton.backgroundColor = self.disabledColor
        doneButton.isEnabled = false
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pin1TextField.becomeFirstResponder()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.clean()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.frame.height
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let closure = cancelClosure {
            closure()
        }
    }
}

extension TOTPEnrollerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let separatorView: UIView?
        switch textField {
        case pin1TextField:
            separatorView = separator1View
        case pin2TextField:
            separatorView = separator2View
        default:
            separatorView = nil
        }
        
        // return NO to not change text
        if string.length == 0 {
            // deletion, allow
            doneButton.backgroundColor = disabledColor
            doneButton.isEnabled = false
            separatorView?.backgroundColor = disabledColor
            return true
        }
        
        let pinString = textField.text ?? ""
        
        guard pinString.length < totpPinLength else {
            return false
        }
        
        let currentPinString = pinString + string
        
        guard currentPinString.length == totpPinLength else {
            doneButton.backgroundColor = disabledColor
            doneButton.isEnabled = false
            separatorView?.backgroundColor = disabledColor
            return true
        }
        
        var pin1: String = pin1TextField.text ?? ""
        var pin2: String = pin2TextField.text ?? ""
        
        switch textField {
        case pin1TextField:
            pin1 = currentPinString
        case pin2TextField:
            pin2 = currentPinString
        default:
            break
        }
        
        let arePinsMatching = pin1 == pin2
        doneButton.backgroundColor = arePinsMatching ? enabledColor : disabledColor
        doneButton.isEnabled = arePinsMatching
        separatorView?.backgroundColor = enabledColor
        if pin1.length == pin2.length && !arePinsMatching {
            separatorView?.backgroundColor = disabledColor
        }
        
        return true
    }
}

extension TOTPEnrollerViewController {
    fileprivate func clean() {
        doneButton.backgroundColor = self.disabledColor
        doneButton.isEnabled = false
        pin1TextField.text = nil
        pin2TextField.text = nil
        pin1TextField.isEnabled = true
        pin2TextField.isEnabled = true
        totpPinLength = 0
        totpTitle = nil
        totpPageDescription = nil
        successClosure = nil
    }
}
