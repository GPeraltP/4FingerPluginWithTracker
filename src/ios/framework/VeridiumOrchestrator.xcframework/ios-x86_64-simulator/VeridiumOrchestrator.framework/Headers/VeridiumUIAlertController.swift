//
//  VeridiumUIAlertControllerViewController.swift
//  VeridiumAuthenticator
//
//  Created by Paul Paul on 4/4/18.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit

public class VeridiumUIAlertController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var okButtonWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var messageScrollableView: UITextView!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var holderHeightConstraint: NSLayoutConstraint!
    
    var cancelBlock:voidBlock? = nil
    var okBlock:voidBlock? = nil
    
    public static func initiate(withTitle:String?, message:String?, okButton:(String, voidBlock?), cancelButton:(String?, voidBlock?)) -> VeridiumUIAlertController {
        let controller:VeridiumUIAlertController = UIStoryboard(name: "ModalViewControllers", bundle: Bundle(identifier: "com.veridiumid.VeridiumOrchestrator")).instantiateViewController(withIdentifier: "VeridiumUIAlertController") as! VeridiumUIAlertController
        controller.loadView()
        controller.okBlock = okButton.1
        controller.cancelBlock = cancelButton.1
        controller.titleLabel.text = withTitle
        controller.okButton.setTitle(okButton.0, for: .normal)
        controller.cancelButton.setTitle(cancelButton.0, for: .normal)
        controller.titleLabel.adjustsFontSizeToFitWidth = true
        
        let font = UIFont(name: controller.messageScrollableView.font?.fontName ?? "OpenSans", size: 14.0)
        controller.messageScrollableView.attributedText = getFormattedText(message)
        controller.messageScrollableView.font = font
        
        // only justify large texts
        if controller.messageScrollableView.attributedText.length > 400 {
            controller.messageScrollableView.textAlignment = .justified
        }
        else {
            controller.messageScrollableView.textAlignment = .center
        }
        
        return controller;
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundView.alpha = 0.0
        self.holderView.layer.cornerRadius = 13.0
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.45
        }
        
        /*
            Try to resize the window to best fit text
         */
        // Check how long the window would be
        let fixedWidth = messageScrollableView.frame.size.width
        var newSize = messageScrollableView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        // resize width also for big texts
        if (newSize.height > 200) {
            newSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: min(UIScreen.main.bounds.height * 0.7, newSize.height))
        }
        else {
            newSize.width = fixedWidth
        }
        
        // block scroll if text fits
        if (newSize.height < UIScreen.main.bounds.height * 0.7) {
            messageScrollableView.isScrollEnabled = false
        }
        
        messageScrollableView.frame.size = newSize;
        messageHeightConstraint.constant = messageScrollableView.frame.size.height
        messageWidthConstraint.constant = messageScrollableView.frame.size.width
        
        if asertIfLabelCanBeHidden(label: titleLabel) {
            holderHeightConstraint.constant = 64
        }
        
        if cancelButton.titleLabel?.text == nil {
            self.cancelButton.isHidden = true
            self.verticalView.isHidden = true
            self.okButtonWidthContraint.addMultiplier(1.0)
        }
        
    }
    
    func asertIfLabelCanBeHidden(label:UILabel) -> Bool {
        if label.text == nil || label.text == "" {
            return true
        }
        return false
    }
    
    @IBAction func onOk(_ sender: Any) {
        self.dissmiss(completion: self.okBlock)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dissmiss(completion: self.cancelBlock)
    }
    
    func dissmiss(completion:voidBlock?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.holderView.frame = CGRect(x: self.holderView.frame.origin.x, y: self.holderView.frame.origin.y + self.view.frame.maxY, width: self.holderView.frame.width, height: self.holderView.frame.height)
        }) { (flag) in
            UIView.animate(withDuration: 0.15, animations: {
                self.backgroundView.alpha = 0.0
            }) { (done) in
                self.dismiss(animated: false, completion: completion)
            }
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    private static func getFormattedText(_ string: String?) -> NSAttributedString? {
        
        guard string != nil else { return nil }
        
        var docType = NSAttributedString.DocumentType.plain
        if (string!.matches("<\\/?.*>") != nil) {
            docType = NSAttributedString.DocumentType.html
        }
        
        do {
            let data = string!.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSMutableAttributedString(data: d,
                                                        options: [.documentType: docType, .characterEncoding:String.Encoding.utf8.rawValue],
                                                        documentAttributes: nil)
                if #available(iOS 13.0, *) {
                    str.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: str.length))
                }
                return str
            }
        } catch {
        }
        return nil
    }
}
