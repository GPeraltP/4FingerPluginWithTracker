//
//  UIViewExtensions.swift
//  VeridiumAuthenticator
//
//  Created by Alex on 18/01/2018.
//  Copyright © 2018 VeridiumIP. All rights reserved.
//

import UIKit
import Foundation

public extension UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIImage {
  func base64EncodedString() -> String? {
    if let imageData: Data = self.pngData() {
      return imageData.base64EncodedString()
    }
    return nil
  }
}

public extension UIViewController {
    func presentVeridiumAlert(_ alert: UIViewController, animated: Bool) {
        self.present(alert, animated: animated)
    }
  func presentVeridiumDismissingAlert(_ alert: UIViewController, animated: Bool, dismissDeadline: DispatchTime, afterDismiss: voidBlock?) {
    self.present(alert, animated: animated, completion: {
      DispatchQueue.main.asyncAfter(deadline: dismissDeadline) {
        self.dismiss(animated: true, completion: afterDismiss)
      }
    })
  }
  func addNavBarImage(image:String) {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: image, in: Bundle(for: GetBundle.self), compatibleWith: nil)?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile), for: .any, barMetrics: .default)
    self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    self.navigationController?.navigationBar.layer.shadowRadius = 4.0
    self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
    self.navigationController?.navigationBar.layer.masksToBounds = false
  }
  
  public func addShaddow(view:UIView) {
    view.layer.cornerRadius = 3.0
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.3
    view.layer.shadowOffset = CGSize.zero
    view.layer.shadowRadius = 3
    view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
  }
  
  public func addVeridiumFontForNavBar() {
    self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 20)!]
  }
    
    public func addVeridiumFontForNavBarItem(label: UILabel) {
        label.font = UIFont(name: "OpenSans-SemiBold", size: 20)
        label.textColor = UIColor.white
    }

  public func enableNaviationSwipe(flag:Bool) {
    let rootNavController = UIApplication.shared.windows[0].rootViewController! as! UINavigationController
    rootNavController.interactivePopGestureRecognizer?.isEnabled = flag
    rootNavController.interactivePopGestureRecognizer?.delegate = nil
  }
  
  public func createBackButtonWithName() -> UIButton {
    let controllerCount = self.navigationController?.viewControllers.count
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(named:"back_btn")?.withRenderingMode(.automatic), for: .normal)
    backButton.setAttributedTitle(NSAttributedString(string: "  \(self.navigationController?.viewControllers[controllerCount! - 2].title ?? "")", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]), for: .normal)
    backButton.sizeToFit()
    return backButton
  }
  
}

class ClosureSleeve {
  let closure: ()->()
  
  init (_ closure: @escaping ()->()) {
    self.closure = closure
  }
  
  @objc func invoke () {
    closure()
  }
}

extension UIControl {
    func add (for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIAlertController {
  
  static func newWithMessage(message: String?, title:String?, cancelButton:(String, voidBlock?), okButton:(String, voidBlock?)) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: cancelButton.0, style: .cancel, handler: { (onCancelPressed) in
      if nil != cancelButton.1 {
        cancelButton.1!()
      }
    }))
    
    alert.addAction(UIAlertAction(title: okButton.0, style: .default, handler: { (onOkPressed) in
      if nil != okButton.1 {
        okButton.1!()
      }
    }))
    alert.presentInTopmost()
  }
  
}

